DwC Agent
=========

Ruby 2.4 gem that cleanses messy Darwin Core terms like [recordedBy][10] or [identifiedBy][11] prior to passing to its dependent Namae gem, which executes the parsing.

[![Gem Version][1]][2]
[![Gem Downloads][8]][9]
[![Continuous Integration Status][3]][4]

Usage
-----

```ruby
require "dwc_agent"
names = DwcAgent.parse '13267 (male) W.J. Cody; 13268 (female) W.E. Kemp'
=> [#<Name family="Cody" given="W.J.">, #<Name family="Kemp" given="W.E.">]
```

License
-------

dwc_agent is released under the [MIT license][5].

Support
-------

Bug reports can be filed at [https://github.com/dshorthouse/dwc_agent/issues][6].

Copyright
---------

Authors: [David P. Shorthouse][7]

Copyright (c) 2018 Canadian Museum of Nature

[1]: https://badge.fury.io/rb/dwc_agent.svg
[2]: http://badge.fury.io/rb/dwc_agent
[3]: https://secure.travis-ci.org/dshorthouse/dwc_agent.svg
[4]: http://travis-ci.org/dshorthouse/dwc_agent
[5]: http://www.opensource.org/licenses/MIT
[6]: https://github.com/dshorthouse/dwc_agent/issues
[7]: https://github.com/dshorthouse
[8]: https://img.shields.io/gem/dt/dwc_agent.svg
[9]: https://rubygems.org/gems/dwc_agent
[10]: http://rs.tdwg.org/dwc/terms/#recordedBy
[11]: http://rs.tdwg.org/dwc/terms/#identifiedBy
