# extractor.cr

* [Homepage](https://github.com/postmodern/xtractor.cr#readme)
* [Issues](https://github.com/postmodern/extractor.cr/issues)
* [Docs](https://postmodern.github.io/docs/extractor.cr/index.html)
* [Email](mailto:postmodern.mod3 at gmail.com)

[Crystal][crystal] bindings to [libextractor], a library for extracting
metadata from a variety of file formats. Inspired by the Ruby [ffi-extractor]
gem and should be API compatible.

[libextractor] is a simple library for keyword extraction.  libextractor
does not support all formats but supports a simple plugging mechanism
such that you can quickly add extractors for additional formats, even
without recompiling libextractor.  libextractor typically ships with a
dozen helper-libraries that can be used to obtain keywords from common
file-types.

libextractor is a part of the [GNU project](http://www.gnu.org/).

## Installation

1. Install `libextractor`

   * Debian

         $ sudo apt-get install libextractor-dev libextractor-plugins-all

   * Ubuntu

         $ sudo apt-get install libextractor-dev libextractor-plugins-all

   * RedHat / Fedora:

         $ sudo yum install libextractor-devel libextractor-plugins

   * Brew:

         $ brew install libextractor

2. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     extractor:
       github: postmodern/extractor.cr
   ```

3. Run `shards install`

## Requirements

* [libextractor] >= 0.6.0

## Examples

```crystal
require "extractor"

Extractor.extract(string) do |plugin_name,type,format,mime_type,data|
  p {plugin, type, format, mime_type,data}
end

Extractor.extract_from("path/to/image.jpg") do |plugin_name,type,format,mime_type,data|
  p {plugin, type, format, mime_type,data}
end
```

## Development

1. Install `libextractor` (See [Installation](#Installation))
2. `git clone https://github.com/postmodern/extractor.cr.git`
3. `cd extractor.cr`
4. `crystal spec`

## Contributing

1. Fork it (<https://github.com/postmodern/extractor.cr/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Postmodern](https://github.com/postmodern) - creator and maintainer

## Copyright

extractor.cr - Crystal bindings for libextractor

Copyright (c) 2020 - Hal Brodigan (postmodern.mod3 at gmail.com)

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

[crystal]: https://crystal-lang.org/
[libextractor]: http://www.gnu.org/software/libextractor
