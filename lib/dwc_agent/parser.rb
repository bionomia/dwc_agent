module DwcAgent
  class Parser

    class << self
      def instance
        Thread.current[:dwc_agent_parser] ||= new
      end
    end

    # Parses the passed-in string and returns a list of names.
    #
    # @param names [String] the name or names to be parsed
    # @return [Array] the list of parsed names
    def parse(name)
      return [] if name.nil? || name == ""
      residual_terminators_regex = Regexp.new SPLIT_BY.to_s + %r{\s*\z}.to_s
      cleaned = name.gsub(STRIP_OUT, ' ')
                    .gsub(/[#{CHAR_SUBS.keys.join('\\')}]/, CHAR_SUBS)
                    .gsub(/(#{PHRASE_SUBS.keys.join('|')})/, PHRASE_SUBS)
                    .gsub(/([A-Z]{1}\.)([[:alpha:]]{2,})/, '\1 \2')
                    .gsub(COMPLEX_SEPARATORS, '\1 | \2')
                    .gsub(residual_terminators_regex, '')
                    .squeeze(' ').strip
      options = { 
        prefer_comma_as_separator: true,
        separator: SPLIT_BY,
        title: TITLE
      }
      namae = Namae::Parser.new(options)
      namae.parse(cleaned)
    end

  end
end