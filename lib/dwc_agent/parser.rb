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

      @strip_out_regex = Regexp.new STRIP_OUT.to_s
      @residual_terminators_regex = Regexp.new SPLIT_BY.to_s + %r{\s*\z}.to_s
      @char_subs_regex = Regexp.new [CHAR_SUBS.keys.join].to_s
      @phrase_subs_regex = Regexp.new((PHRASE_SUBS.keys.join('|')).to_s, Regexp::IGNORECASE)
      @complex_separators_regex = Regexp.new COMPLEX_SEPARATORS.to_s
      @add_separators_regex = Regexp.new %r{(\S{1}\.)([[:alpha:]]{2,})}.to_s
    end

    # Parses the passed-in string and returns a list of names.
    #
    # @param names [String] the name or names to be parsed
    # @return [Array] the list of parsed names
    def parse(name)
      return [] if name.nil? || name == ""
      name.gsub!(@strip_out_regex, ' ')
      name.gsub!(/\[|\]/, '')
      name.gsub!(@char_subs_regex, CHAR_SUBS)
      name.gsub!(@phrase_subs_regex, PHRASE_SUBS)
      name.gsub!(@add_separators_regex, '\1 \2')
      name.gsub!(@complex_separators_regex, '\1 | \2')
      name.gsub!(@residual_terminators_regex, '')
      name.squeeze!(' ')
      name.strip!
      @namae.parse(name)
    end

  end
end
