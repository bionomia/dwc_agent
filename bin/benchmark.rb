#!/usr/bin/env ruby
# encoding: utf-8
require 'benchmark'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'dwc_agent'

namestring = "A.D. and P. Smith"
parsed = DwcAgent.parse(namestring)[0]

iterations = 1000

Benchmark.bm do |bm|

  bm.report("similarity") do
    iterations.times do
      DwcAgent.similarity_score("Peter", "Peter Michael")
    end
  end

  bm.report("namae") do
    iterations.times do
      Namae.parse(namestring)
    end
  end

  bm.report("dwc_agent_parser") do
    iterations.times do
      DwcAgent.parse(namestring)
    end
  end

  bm.report("dwc_agent_cleaner") do
    iterations.times do
      DwcAgent.clean(parsed)
    end
  end

  bm.report("dwc_agent_combined") do
    iterations.times do
      DwcAgent.parse(namestring).each do |a|
        DwcAgent.clean(a)
      end
    end
  end

end
