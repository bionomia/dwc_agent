DwC Agent
=========

Ruby 3.0 gem that cleanses messy Darwin Core terms like [recordedBy][10] or [identifiedBy][11] prior to passing to its dependent Namae gem, which executes the parsing. It also produces similarity scores between two given names.

[![Gem Version][1]][2]
[![Gem Downloads][8]][9]
[![Continuous Integration Status][3]][4]

Usage
-----

```ruby
require "dwc_agent"
names = DwcAgent.parse '13267 (male) W.J. Cody; 13268 (female) W.E. Kemp'
=>
[#<struct Namae::Name family="Cody", given="W.J.", suffix=nil, particle=nil, dropping_particle=nil, nick=nil, appellation=nil, title=nil>,
 #<struct Namae::Name family="Kemp", given="W.E.", suffix=nil, particle=nil, dropping_particle=nil, nick=nil, appellation=nil, title=nil>]
```

Parsing is occasionally messy & so it is advisable to make use of the additional `clean` method for each parsed name.

```ruby
require "dwc_agent"
names = DwcAgent.parse 'Chaboo, Bennett, Shin'
=>
[#<struct Namae::Name family=nil, given="Chaboo", suffix=nil, particle=nil, dropping_particle=nil, nick=nil, appellation=nil, title=nil>,
 #<struct Namae::Name family=nil, given="Bennett", suffix=nil, particle=nil, dropping_particle=nil, nick=nil, appellation=nil, title=nil>,
 #<struct Namae::Name family=nil, given="Shin", suffix=nil, particle=nil, dropping_particle=nil, nick=nil, appellation=nil, title=nil>]
DwcAgent.clean names[0]
=> #<struct Namae::Name family="Chaboo", given=nil, suffix=nil, particle=nil, dropping_particle=nil, nick=nil, appellation=nil, title=nil>
```

A cleaned name might produce all nil attributes if it does not pass logic checks. You can use a utility method to see if this is the case:

```ruby
if cleaned_name != DwcAgent.default
  # Do something with the Namae::Name attributes
else
  # Perhaps use your unparsed input some other way
end
```

There's also a similarity score to compare the structure of two given names. The greater the score, the more likely aliases refer to the "same" name. For instance, "John C." scores a 2 when compared to "John Charles", a 1.1 when compared to "John" alone whereas it scores a 0 when compared to "Joshua" or "John R.". Given two names that share the same family name, this utility method could be used to down-weight search results if the given name portions are unlikely matches.

```ruby
require "dwc_agent"
score = DwcAgent.similarity_score('John C.', 'John')
=> 1.1
```

Or, from the command-line:

```bash
gem install dwc_agent
dwcagent "13267 (male) W.J. Cody; 13268 (female) W.E. Kemp"
=> [{"title":null,"appellation":null,"given":"W.J.","particle":null,"family":"Cody","suffix":null,"dropping_particle":null,"nick":null},{"title":null,"appellation":null,"given":"W.E.","particle":null,"family":"Kemp","suffix":null,"dropping_particle":null,"nick":null}]
```

```bash
gem install dwc_agent
dwcagent-similarity "John C." "John"
=> 1.1
```

License
-------

dwc_agent is released under the [MIT license][5].

Support
-------

Bug reports can be filed at [https://github.com/bionomia/dwc_agent/issues][6].

Copyright
---------

Authors: [David P. Shorthouse][7]

Copyright (c) 2024

[1]: https://badge.fury.io/rb/dwc_agent.svg
[2]: http://badge.fury.io/rb/dwc_agent
[3]: https://github.com/bionomia/dwc_agent/actions/workflows/ruby.yml/badge.svg
[4]: https://github.com/bionomia/dwc_agent/actions
[5]: http://www.opensource.org/licenses/MIT
[6]: https://github.com/bionomia/dwc_agent/issues
[7]: https://github.com/dshorthouse
[8]: https://img.shields.io/gem/dt/dwc_agent.svg
[9]: https://rubygems.org/gems/dwc_agent
[10]: http://rs.tdwg.org/dwc/terms/recordedBy
[11]: http://rs.tdwg.org/dwc/terms/identifiedBy
