module DwcAgent

  class Parser

    @defaults = {
      prefer_comma_as_separator: true,
      separator: SPLIT_BY,
      title: TITLE,
      appellation: APPELLATION,
      suffix: SUFFIX,
      strip_out_regex: Regexp.new(STRIP_OUT.to_s),
      tidy_remains_regex: Regexp.new(POST_STRIP_TIDY.to_s),
      subs_regex: Regexp.new(CHAR_SUBS.keys.map{|a| Regexp.escape a }.join('|').to_s),
      complex_separators_regex: COMPLEX_SEPARATORS.map{|k,v| [ Regexp.new(k), v] },
      residual_terminators_regex: Regexp.new(SPLIT_BY.to_s + %r{\s*\z}.to_s)
    }

    class << self
      attr_reader :defaults

      def instance
        Thread.current[:dwc_agent_parser] ||= new
      end
    end

    attr_reader :options, :namae

    def initialize(options = {})
      @options = self.class.defaults.merge(options)
      @namae = Namae::Parser.new(@options)
    end

    # Parses the passed-in string and returns a list of names.
    #
    # @param names [String] the name or names to be parsed
    # @return [Array] the list of parsed names
    def parse(name)
      return [] if name.nil? || name == ""
      name.gsub!(options[:strip_out_regex], ' ')
      name.gsub!(options[:tidy_remains_regex], '')
      name.gsub!(options[:subs_regex], CHAR_SUBS)
      options[:complex_separators_regex].each{|k| name.gsub!(k[0], k[1])}
      name.gsub!(options[:residual_terminators_regex], '')
      name.squeeze!(' ')
      name.strip!
      namae.parse(name)
    end

  end

end
