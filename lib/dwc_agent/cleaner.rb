module DwcAgent
  class Cleaner

    class << self
      def instance
        Thread.current[:dwc_agent_cleaner] ||= new
      end
    end

    def initialize
    end

    # Cleans the passed-in namae object from the parse method and
    # re-organizes it to better match expected Darwin Core output.
    #
    # @param parsed_namae [Object] the namae object
    # @return [Hash] the given, family hash
    def clean(parsed_namae)
      blank_name = { given: nil, family: nil, particle: nil }

      if parsed_namae.family && FAMILY_BLACKLIST.any?{ |s| s.casecmp(parsed_namae.family) == 0 }
        return blank_name
      end

      if parsed_namae.family && parsed_namae.family.length < 2 && parsed_namae.family.count('.') == 0
        #return blank_name
      end

      if parsed_namae.family && parsed_namae.family.length == 3 && parsed_namae.family.count('.') == 1
        return blank_name
      end

      if parsed_namae.given && parsed_namae.given.length > 25
        return blank_name
      end

      if parsed_namae.given && parsed_namae.given.count('.') >= 3 && /\.\s*[a-zA-Z]{4,}\s+[a-zA-Z]{1,}\./.match(parsed_namae.given)
        return blank_name
      end

      if parsed_namae.display_order =~ BLACKLIST
        return blank_name
      end

      if parsed_namae.given && 
         parsed_namae.family && 
         parsed_namae.family.count(".") > 0 && 
         parsed_namae.family.length - parsed_namae.family.count(".") <= 3
          given = parsed_namae.given
          family = parsed_namae.family
          parsed_namae.family = given
          parsed_namae.given = family
      end

      if parsed_namae.given && 
         parsed_namae.family && 
         parsed_namae.family.length <=3 && 
         parsed_namae.family == parsed_namae.family.upcase &&
         parsed_namae.given[-1] != "."
          given = parsed_namae.given
          family = parsed_namae.family
          parsed_namae.family = given
          parsed_namae.given = family
      end

      if parsed_namae.given && 
        (parsed_namae.given == parsed_namae.given.upcase || 
        parsed_namae.given == parsed_namae.given.downcase) && 
        !parsed_namae.given.include?(".") &&
        parsed_namae.given.tr(".","").length >= 4
          parsed_namae.given = NameCase(parsed_namae.given)
      end

      if parsed_namae.given && /\.[A-Z]$/.match(parsed_namae.given)
        parsed_namae.given += "."
      end

      if parsed_namae.given && /[A-Za-z]\./.match(parsed_namae.given)
        parsed_namae.given = NameCase(parsed_namae.given)
      end

      parsed_namae.normalize_initials

      family = parsed_namae.family.gsub(/\.\z/, '').strip rescue nil
      given = parsed_namae.given.strip rescue nil
      particle = parsed_namae.particle.strip rescue nil

      if !given.nil? && given.match(/[A-Z]\.[A-Za-z]{2,}/)
        given = given.gsub(".", ". ").strip
      end

      if family.nil? && !given.nil? && !given.include?(".")
        family = given
        given = nil
      end

      if !family.nil? && given.nil? && !particle.nil?
        given = particle.sub(/[a-z]\./, &:upcase).sub(/^(.)/) { $1.capitalize }
        particle = nil
      end

      if !particle.nil? && particle.include?(".")
        particle = nil
      end

      if !family.nil? && (family == family.upcase || family == family.downcase)
        family = NameCase(family)
      end

      if !family.nil? && family.match(/[A-Z]$/)
        return blank_name
      end

      if !family.nil? && family.match(/^[A-Z]{2}/)
        return blank_name
      end

      if !family.nil? && FAMILY_BLACKLIST.any?{ |s| s.casecmp(family) == 0 }
        return blank_name
      end

      { given: given, family: family, particle: particle }
    end

  end
end