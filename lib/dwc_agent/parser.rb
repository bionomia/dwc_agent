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
        title: TITLE,
        appellation: APPELLATION,
        suffix: SUFFIX
      }
      @namae = Namae::Parser.new(options)
      @strip_out_regex = Regexp.new STRIP_OUT.to_s
      @char_subs_regex = Regexp.new [CHAR_SUBS.keys.join].to_s
      @phrase_subs_regex = Regexp.new PHRASE_SUBS.keys.map{|a| Regexp.escape a }.join('|').to_s
      @residual_terminators_regex = Regexp.new SPLIT_BY.to_s + %r{\s*\z}.to_s
      @separators = SEPARATORS.map{|k,v| [ Regexp.new(k), v] }
    end

    # Parses the passed-in string and returns a list of names.
    #
    # @param names [String] the name or names to be parsed
    # @return [Array] the list of parsed names
    def parse(name)
      return [] if name.nil? || name == ""
      name.gsub!(@strip_out_regex, ' ')
      name.gsub!(Regexp.union(@char_subs_regex, @phrase_subs_regex), CHAR_SUBS.merge(PHRASE_SUBS))
      @separators.each{|k| name.gsub!(k[0], k[1])}
      name.gsub!(@residual_terminators_regex, '')
      name.squeeze!(' ')
      name.strip!
      @namae.parse(name)
    end

  end
end
