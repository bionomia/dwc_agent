#!/usr/bin/env ruby
# encoding: utf-8
require 'dwc_agent'
require 'benchmark'

namestring = "Smith, William Leo; Bentley, Andrew C; Girard, Matthew G; Davis, Matthew P; Ho, Hsuan-Ching"

parsed = DwcAgent.parse(namestring)

iterations = 2500

Benchmark.bm do |bm|

  bm.report("uniq") do
    iterations.times do
      [{family: "Smith", given: "Michael"}, {family: "Smith", given: "M."}].uniq
    end
  end

  bm.report("dwc_agent") do
    iterations.times do
      DwcAgent.parse(namestring)
    end
  end

  bm.report("namae") do
    iterations.times do
      Namae.parse(namestring)
    end
  end

  bm.report("dwc_agent-clean") do
    DwcAgent.clean(parsed[1])
  end

end