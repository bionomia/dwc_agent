$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'json'
require 'dwc_agent'

def set_parser(parser)
  @parser = parser
end

def set_cleaner(cleaner)
  @cleaner = cleaner
end

def parse(input)
  @parser.parse(input)
end

def clean(input)
  @cleaner.clean(input)
end

def json(input)
  parse(input).map{ |a| clean(a) }.to_json
end

def read_test_file
  f = open(File.expand_path("../resources/test_data.txt", __FILE__))
  f.each do |line|
    input, expected = line.split(" || ")
    if line.match(/^\s*#/) == nil && input && expected
      yield({ input: input, expected: expected })
    else
      yield({ comment: line })
    end
  end
end