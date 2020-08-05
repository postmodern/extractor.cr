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

@[Link("extractor")]
lib LibExtractor
  alias Char = LibC::Char
  alias Int = LibC::Int
  alias SizeT = LibC::SizeT

  #
  # Options for how plugin execution should be done.
  #
  enum Options
    #
    # Run plugin out-of-process, starting the process once the plugin
    # is to be run.  If a plugin crashes, automatically restart the
    # respective process for the same file and try once more
    # (since the crash may be caused by the previous file).  If
    # the process crashes immediately again, it is not restarted
    # until the next file.
    #
    DEFAULT_POLICY = 0

    #
    # Deprecated option.  Ignored.
    #
    OUT_OF_PROCESS_NO_RESTART = 1

    #
    # Run plugins in-process.  Unsafe, not recommended,
    # can be nice for debugging.
    #
    IN_PROCESS = 2

    #
    # Internal value for plugins that have been disabled.
    #
    DISABLED = 3
  end

  #
  # Format in which the extracted meta data is presented.
  # 
  enum MetaFormat
    #
    # Format is unknown.
    #
    UNKNOWN = 0

    #
    # 0-terminated, UTF-8 encoded string.  "data_len"
    # is strlen(data)+1.
    #
    UTF8 = 1

    #
    # Some kind of binary format, see given Mime type.
    #
    BINARY = 2

    #
    # 0-terminated string.  The specific encoding is unknown.
    # "data_len" is strlen (data)+1.
    #
    C_STRING = 3
  end

  #
  # Enumeration defining various sources of keywords.  See also
  # http://dublincore.org/documents/1998/09/dces/
  #
  enum MetaType
    # fundamental types
    RESERVED = 0
    MIMETYPE = 1
    FILENAME = 2
    COMMENT = 3

    # Standard types from bibtex
    TITLE = 4
    BOOK_TITLE = 5
    BOOK_EDITION = 6
    BOOK_CHAPTER_NUMBER = 7
    JOURNAL_NAME = 8
    JOURNAL_VOLUME = 9
    JOURNAL_NUMBER = 10
    PAGE_COUNT = 11
    PAGE_RANGE = 12
    AUTHOR_NAME = 13
    AUTHOR_EMAIL = 14
    AUTHOR_INSTITUTION = 15
    PUBLISHER = 16
    PUBLISHER_ADDRESS = 17
    PUBLISHER_INSTITUTION = 18
    PUBLISHER_SERIES = 19
    PUBLICATION_TYPE = 20
    PUBLICATION_YEAR = 21
    PUBLICATION_MONTH = 22
    PUBLICATION_DAY = 23
    PUBLICATION_DATE = 24
    BIBTEX_EPRINT = 25
    BIBTEX_ENTRY_TYPE = 26
    LANGUAGE = 27
    CREATION_TIME = 28
    URL = 29

    # "unique" document identifiers
    URI = 30
    ISRC = 31
    HASH_MD4 = 32
    HASH_MD5 = 33
    HASH_SHA0 = 34
    HASH_SHA1 = 35
    HASH_RMD160 = 36

    # identifiers of a location
    GPS_LATITUDE_REF = 37
    GPS_LATITUDE = 38
    GPS_LONGITUDE_REF = 39
    GPS_LONGITUDE = 40
    LOCATION_CITY = 41
    LOCATION_SUBLOCATION = 42
    LOCATION_COUNTRY = 43
    LOCATION_COUNTRY_CODE = 44

    # generic attributes
    UNKNOWN = 45
    DESCRIPTION = 46
    COPYRIGHT = 47
    RIGHTS = 48
    KEYWORDS = 49
    ABSTRACT = 50
    SUMMARY = 51
    SUBJECT = 52
    CREATOR = 53
    FORMAT = 54
    FORMAT_VERSION = 55

    # processing history
    CREATED_BY_SOFTWARE = 56
    UNKNOWN_DATE = 57
    CREATION_DATE = 58
    MODIFICATION_DATE = 59
    LAST_PRINTED = 60
    LAST_SAVED_BY = 61
    TOTAL_EDITING_TIME = 62
    EDITING_CYCLES = 63
    MODIFIED_BY_SOFTWARE = 64
    REVISION_HISTORY = 65

    EMBEDDED_FILE_SIZE = 66
    FINDER_FILE_TYPE = 67
    FINDER_FILE_CREATOR = 68

    # software package specifics (deb, rpm, tgz, elf)
    PACKAGE_NAME = 69
    PACKAGE_VERSION = 70
    SECTION = 71
    UPLOAD_PRIORITY = 72
    PACKAGE_DEPENDENCY = 73
    PACKAGE_CONFLICTS = 74
    PACKAGE_REPLACES = 75
    PACKAGE_PROVIDES = 76
    PACKAGE_RECOMMENDS = 77
    PACKAGE_SUGGESTS = 78
    PACKAGE_MAINTAINER = 79
    PACKAGE_INSTALLED_SIZE = 80
    PACKAGE_SOURCE = 81
    PACKAGE_ESSENTIAL = 82
    TARGET_ARCHITECTURE = 83
    PACKAGE_PRE_DEPENDENCY = 84
    LICENSE = 85
    PACKAGE_DISTRIBUTION = 86
    BUILDHOST = 87
    VENDOR = 88
    TARGET_OS = 89
    SOFTWARE_VERSION = 90
    TARGET_PLATFORM = 91
    RESOURCE_TYPE = 92
    LIBRARY_SEARCH_PATH = 93
    LIBRARY_DEPENDENCY = 94

    # photography specifics
    CAMERA_MAKE = 95
    CAMERA_MODEL = 96
    EXPOSURE = 97
    APERTURE = 98
    EXPOSURE_BIAS = 99
    FLASH = 100
    FLASH_BIAS = 101
    FOCAL_LENGTH = 102
    FOCAL_LENGTH_35MM = 103
    ISO_SPEED = 104
    EXPOSURE_MODE = 105
    METERING_MODE = 106
    MACRO_MODE = 107
    IMAGE_QUALITY = 108
    WHITE_BALANCE = 109
    ORIENTATION = 110
    MAGNIFICATION = 111

    # image specifics
    IMAGE_DIMENSIONS = 112
    PRODUCED_BY_SOFTWARE = 113
    THUMBNAIL = 114
    IMAGE_RESOLUTION = 115
    SOURCE = 116

    # (text) document processing specifics
    CHARACTER_SET = 117
    LINE_COUNT = 118
    PARAGRAPH_COUNT = 119
    WORD_COUNT = 120
    CHARACTER_COUNT = 121
    PAGE_ORIENTATION = 122
    PAPER_SIZE = 123
    TEMPLATE = 124
    COMPANY = 125
    MANAGER = 126
    REVISION_NUMBER = 127

    # music / video specifics
    DURATION = 128
    ALBUM = 129
    ARTIST = 130
    GENRE = 131
    TRACK_NUMBER = 132
    DISC_NUMBER = 133
    PERFORMER = 134
    CONTACT_INFORMATION = 135
    SONG_VERSION = 136
    PICTURE = 137
    COVER_PICTURE = 138
    CONTRIBUTOR_PICTURE = 139
    EVENT_PICTURE = 140
    LOGO = 141
    BROADCAST_TELEVISION_SYSTEM = 142
    SOURCE_DEVICE = 143
    DISCLAIMER = 144
    WARNING = 145
    PAGE_ORDER = 146
    WRITER = 147
    PRODUCT_VERSION = 148
    CONTRIBUTOR_NAME = 149
    MOVIE_DIRECTOR = 150
    NETWORK_NAME = 151
    SHOW_NAME = 152
    CHAPTER_NAME = 153
    SONG_COUNT = 154
    STARTING_SONG = 155
    PLAY_COUNTER = 156
    CONDUCTOR = 157
    INTERPRETATION = 158
    COMPOSER = 159
    BEATS_PER_MINUTE = 160
    ENCODED_BY = 161
    ORIGINAL_TITLE = 162
    ORIGINAL_ARTIST = 163
    ORIGINAL_WRITER = 164
    ORIGINAL_RELEASE_YEAR = 165
    ORIGINAL_PERFORMER = 166
    LYRICS = 167
    POPULARITY_METER = 168
    LICENSEE = 169
    MUSICIAN_CREDITS_LIST = 170
    MOOD = 171
    SUBTITLE = 172

    # GNUnet specific values (never extracted)
    GNUNET_DISPLAY_TYPE = 173
    GNUNET_FULL_DATA = 174
    RATING = 175
    ORGANIZATION = 176
    RIPPER = 177
    PRODUCER = 178
    GROUP = 179
    GNUNET_ORIGINAL_FILENAME = 180

    DISC_COUNT = 181

    CODEC = 182
    VIDEO_CODEC = 183
    AUDIO_CODEC = 184
    SUBTITLE_CODEC = 185

    CONTAINER_FORMAT = 186

    BITRATE = 187
    NOMINAL_BITRATE = 188
    MINIMUM_BITRATE = 189
    MAXIMUM_BITRATE = 190

    SERIAL = 191

    ENCODER = 192
    ENCODER_VERSION = 193

    TRACK_GAIN = 194
    TRACK_PEAK = 195
    ALBUM_GAIN = 196
    ALBUM_PEAK = 197
    REFERENCE_LEVEL = 198

    LOCATION_NAME = 199
    LOCATION_ELEVATION = 200
    LOCATION_HORIZONTAL_ERROR = 201
    LOCATION_MOVEMENT_SPEED = 202
    LOCATION_MOVEMENT_DIRECTION = 203
    LOCATION_CAPTURE_DIRECTION = 204

    SHOW_EPISODE_NUMBER = 205
    SHOW_SEASON_NUMBER = 206

    GROUPING = 207

    DEVICE_MANUFACTURER = 208
    DEVICE_MODEL = 209

    AUDIO_LANGUAGE = 210
    CHANNELS = 211
    SAMPLE_RATE = 212
    AUDIO_DEPTH = 213
    AUDIO_BITRATE = 214
    MAXIMUM_AUDIO_BITRATE = 215

    VIDEO_DIMENSIONS = 216
    VIDEO_DEPTH = 217
    FRAME_RATE = 218
    PIXEL_ASPECT_RATIO = 219
    VIDEO_BITRATE = 220
    MAXIMUM_VIDEO_BITRATE = 221

    SUBTITLE_LANGUAGE = 222
    VIDEO_LANGUAGE = 223

    TOC = 224

    VIDEO_DURATION = 225
    AUDIO_DURATION = 226
    SUBTITLE_DURATION = 227

    AUDIO_PREVIEW = 228

    NARINFO = 229
    NAR = 230

    LAST = 231

    def to_s : String
      String.new(LibExtractor.EXTRACTOR_metatype_to_string(self))
    end

    def description : String
      String.new(LibExtractor.EXTRACTOR_metatype_to_description(self))
    end

  end

  fun EXTRACTOR_metatype_to_string(type : MetaType) : Char * 
  fun EXTRACTOR_metatype_to_description(type : MetaType) : Char *
  fun EXTRACTOR_metatype_get_max() : MetaType

  alias MetaDataProcessor = (Void *,
                             Char *,
                             MetaType,
                             MetaFormat,
                             Char *,
                             Char *,
                             SizeT) -> Int

  struct ExtractContext
    cls : Void *

    config : Char *

    read : (Void *, Pointer(Void *), SizeT) -> SizeT

    seek : (Void *, Int64, Int) -> Int64

    get_size : (Void *) -> UInt64

    proc : MetaDataProcessor

  end

  alias ExtractMethod = (Pointer(ExtractContext)) -> 

  alias PluginListPtr = Void *

  fun EXTRACTOR_plugin_add_defaults(flags : Options) : PluginListPtr
  fun EXTRACTOR_plugin_add(prev : PluginListPtr, library : Char *, options : Char *, flags : Options) : PluginListPtr
  fun EXTRACTOR_plugin_add_config(prev : PluginListPtr, config : Char *, flags : Options) : PluginListPtr
  fun EXTRACTOR_plugin_remove(prev : PluginListPtr, library : Char *) : PluginListPtr
  fun EXTRACTOR_plugin_remove_all(plugins : PluginListPtr) : Void

  fun EXTRACTOR_extract(plugin : PluginListPtr,
                        filename : Char *,
                        data : Void *,
                        size : SizeT,
                        proc : MetaDataProcessor,
                        proc_cls : Void *) : Void
  fun EXTRACTOR_meta_data_print(handle : Void *,
                                plugin_name : Char *,
                                type : MetaType,
                                format : MetaFormat,
                                data_mime_type : Char *,
                                data : Char *,
                                data_len : SizeT) : Int
end
