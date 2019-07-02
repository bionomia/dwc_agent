#!/usr/bin/env ruby
# encoding: utf-8
require 'benchmark'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'dwc_agent'

namestring = "Smith, William Leo; Bentley, Andrew C; Girard, Matthew G; Davis, Matthew P; Ho, Hsuan-Ching"

parsed = DwcAgent.parse(namestring)

iterations = 2500

Benchmark.bm do |bm|

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

end