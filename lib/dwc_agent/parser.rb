module DwcAgent
  class Parser

    class << self
      def instance
        Thread.current[:dwc_agent_parser] ||= new
      end
    end

    def initialize
      options = { 
        prefer_comma_as_separator: true,
        separator: SPLIT_BY,
        title: TITLE
      }
      @namae = Namae::Parser.new(options)
    end
      
    # Parses the passed-in string and returns a list of names.
    #
    # @param names [String] the name or names to be parsed
    # @return [Array] the list of parsed names
    def parse(name)
      return [] if name.nil? || name == ""
      residual_terminators_regex = Regexp.new SPLIT_BY.to_s + %r{\s*\z}.to_s
      name.gsub!(STRIP_OUT, ' ')
      name.gsub!(/[#{CHAR_SUBS.keys.join('\\')}]/, CHAR_SUBS)
      name.gsub!(/(#{PHRASE_SUBS.keys.join('|')})/, PHRASE_SUBS)
      name.gsub!(/([A-Z]{1}\.)([[:alpha:]]{2,})/, '\1 \2')
      name.gsub!(COMPLEX_SEPARATORS, '\1 | \2')
      name.gsub!(residual_terminators_regex, '')
      name.squeeze!(' ')
      name.strip!
      @namae.parse(name)
    end

  end
end