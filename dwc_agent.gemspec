$:.push File.expand_path("../lib", __FILE__)

require "dwc_agent/version"

Gem::Specification.new do |s|
  s.required_ruby_version = '~> 2.6'
  s.name        = 'dwc_agent'
  s.version     = DwcAgent::Version.version
  s.license     = 'MIT'
  s.date        = '2020-08-06'
  s.summary     = "Parse Darwin Core agent terms such as recordedBy and identifiedBy"
  s.description = "Parses the typically messy content in Darwin Core terms that contain people names"
  s.authors     = ["David P. Shorthouse"]
  s.email       = 'davidpshorthouse@gmail.coms'
  s.homepage    = 'https://github.com/bionomia/dwc_agent'

  s.files        = Dir['MIT-LICENSE', 'README.rdoc', 'lib/**/*']
  s.executables  = ["dwcagent", "dwcagent-similarity"]
  s.require_path = 'lib'
  s.rdoc_options.concat ['--encoding',  'UTF-8']
  s.add_runtime_dependency "namae", "~> 1"
  s.add_runtime_dependency "namecase", "~> 2"
  s.add_development_dependency "rake", "~> 12"
  s.add_development_dependency "rspec", "~> 3.4"
  s.add_development_dependency "bundler", "~> 2"
end
