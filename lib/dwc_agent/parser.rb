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
      char_subs_regex: Regexp.new([CHAR_SUBS.keys.join].to_s),
      phrase_subs_regex: Regexp.new(PHRASE_SUBS.keys.map{|a| Regexp.escape a }.join('|').to_s),
      residual_terminators_regex: Regexp.new(SPLIT_BY.to_s + %r{\s*\z}.to_s),
      separators: SEPARATORS.map{|k,v| [ Regexp.new(k), v] }
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
      name.gsub!(Regexp.union(options[:char_subs_regex], options[:phrase_subs_regex]), CHAR_SUBS.merge(PHRASE_SUBS))
      options[:separators].each{|k| name.gsub!(k[0], k[1])}
      name.gsub!(options[:residual_terminators_regex], '')
      name.squeeze!(' ')
      name.strip!
      namae.parse(name)
    end

  end

end
