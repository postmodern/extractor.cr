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
  class PluginsLoadError < RuntimeError
  end

  class PluginNotFound < RuntimeError
  end

  class UnknownPlugin < RuntimeError
  end

  #
  # Represents the list of loaded extractor plugins.
  #
  class PluginList

    #
    # Initializes the plugin list.
    #
    def initialize(@ptr = LibExtractor::PluginListPtr.null)
    end

    #
    # Releases the plugin list.
    #
    def self.release(ptr : Pointer)
      LibExtractor.EXTRACTOR_plugin_remove_all(ptr)
    end

    alias Options = LibExtractor::Options

    #
    # Loads the installed extractor plugins.
    #
    @[Raises(PluginsLoadError)]
    def self.default(policy = Options::DEFAULT_POLICY)
      ptr = LibExtractor.EXTRACTOR_plugin_add_defaults(policy)

      if ptr.null?
        raise PluginsLoadError.new("no plugins were loaded")
      end

      return new(ptr)
    end

    alias PluginName = Symbol | String

    #
    # Loads a plugin and adds it to the list.
    #
    @[Raises(PluginNotFound)]
    def add(name : PluginName, options = "", flags = Options::DEFAULT_POLICY) : PluginList
      name    = name.to_s
      new_ptr = LibExtractor.EXTRACTOR_plugin_add(@ptr,name,options,flags)

      if new_ptr == @ptr
        raise PluginNotFound.new("could not add #{name.inspect} to the plugin list")
      end

      @ptr = new_ptr
      return self
    end

    #
    # Removes a plugin from the list.
    #
    @[Raises(UnknownPlugin)]
    def remove(name : PluginName) : PluginList
      name    = name.to_s
      new_ptr = LibExtractor.EXTRACTOR_plugin_remove(@ptr,name)

      if new_ptr == @ptr
        raise UnknownPlugin.new("could not remove #{name.inspect} from the plugin list")
      end

      @ptr = new_ptr
      return self
    end

    @[AlwaysInline]
    def delete
      remove
    end

    #
    # Removes all plugins from the list.
    #
    def remove_all : PluginList
      LibExtractor.EXTRACTOR_plugin_remove_all(@ptr)
      return self
    end

    @[AlwaysInline]
    def clear
      remove_all
    end

    #
    # Returns the underlying pointer.
    #
    def to_unsafe : LibExtractor::PluginListPtr
      @ptr
    end

  end
end
