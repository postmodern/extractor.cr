#
# extractor.cr - Crystal bindings for libextractor
#
# Copyright (c) 2020 - Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

module Extractor
  class MetadataProcessor

    alias Char = LibC::Char
    alias SizeT = LibC::SizeT
    alias MetaType = LibExtractor::MetaType
    alias MetaFormat = LibExtractor::MetaFormat
    alias MetaData = String | Bytes | Slice(UInt8)
    alias Callback = (String, MetaType, MetaFormat, String, MetaData) ->

    class Abort < RuntimeError
    end

    # Mapping of plugin paths to names
    PLUGIN_NAMES = Hash(String, String).new do |plugin_names,plugin|
      libname = File.basename(plugin,File.extname(plugin))

      plugin_names[plugin] = libname.sub("libextractor_","")
    end

    getter callback : Pointer(Void)

    #
    # Wraps a Metadata Processor callback.
    #
    def initialize(&block : Callback)
      @callback = Box.box(block)
    end

    #
    # Invokes the callback.
    #
    def call(cls : Void *, plugin : Char *, type : MetaType, format : MetaFormat, mime_type : Char *, data : Char *, size : SizeT) : Int32
      callback    = Box(Callback).unbox(cls)
      plugin_name = PLUGIN_NAMES[String.new(plugin)]
      mime_type   = String.new(mime_type)
      value       = case format
                    when MetaFormat::C_STRING
                      String.new(Bytes.new(data,size - 1),"ASCII")
                    when MetaFormat::UTF8
                      String.new(Bytes.new(data,size - 1),"UTF-8")
                    else
                      Slice.new(data,size)
                    end

      begin
        callback.call(plugin_name,type,format,mime_type,value)

        0
      rescue Abort
        1
      end
    end

    #
    # Returns a proc literal for the `call` method.
    #
    def to_unsafe
      ->call(Void *, Char *, MetaType, MetaFormat, Char *, Char *, SizeT)
    end

  end
end
