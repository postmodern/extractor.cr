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

require "./libextractor"
require "./extractor/plugin_list"
require "./extractor/metadata_processor"

module Extractor
  VERSION = "0.1.0"

  alias Options = LibExtractor::Options
  alias MetaType = LibExtractor::MetaType
  alias MetaFormat = LibExtractor::MetaFormat
  alias MetaData = MetadataProcessor::MetaData

  @@plugins : PluginList? = nil

  #
  # The default list of plugins.
  #
  def self.plugins : PluginList
    @@plugins ||= PluginList.default
  end

  #
  # Aborts metadata extraction.
  #
  @[Raises(MetadataProcessor::Abort)]
  def self.abort!
    raise(MetadataProcessor::Abort.new)
  end

  #
  # Extracts metadata from the given String.
  #
  def self.extract(data : String, plugins = Extractor.plugins, &block : MetadataProcessor::Callback)
    processor = MetadataProcessor.new(&block)

    LibExtractor.EXTRACTOR_extract(plugins,nil,data,data.size,processor,processor.callback)
  end

  #
  # Extracts metadata from a file.
  #
  def self.extract_from(path : String | Path, plugins = Extractor.plugins, &block : MetadataProcessor::Callback)
    processor = MetadataProcessor.new(&block)

    LibExtractor.EXTRACTOR_extract(plugins,path,nil,0,processor,processor.callback)
  end
end
