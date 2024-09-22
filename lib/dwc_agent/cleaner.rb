module DwcAgent

  class Cleaner

    class << self
      def instance
        Thread.current[:dwc_agent_cleaner] ||= new
      end
    end

    def initialize
      @blacklist = BLACKLIST
      @given_blacklist = GIVEN_BLACKLIST
      @family_blacklist = FAMILY_BLACKLIST
      @particles = PARTICLES
    end

    def default
      DwcAgent.default
    end

    # Cleans the passed-in namae object from the parse method and
    # re-organizes it to better match expected Darwin Core output.
    #
    # @param parsed_namae [Namae::Name] a Namae object
    # @return Namae::Name [Object] a new Namae object
    def clean(parsed_namae)

      if parsed_namae.family &&
         parsed_namae.family == NameCase(parsed_namae.family) &&
         parsed_namae.display_order.split.join == parsed_namae.initials
        return default
      end

      if parsed_namae.given &&
         @given_blacklist.any?{ |s| s.casecmp(parsed_namae.given) == 0 }
        return
      end

      if parsed_namae.family &&
         parsed_namae.family.length == 3 &&
         parsed_namae.family.count('.') == 1
        return default
      end

      if parsed_namae.given && parsed_namae.given.length > 35
        return default
      end

      if parsed_namae.given &&
         parsed_namae.given.count('.') >= 3 &&
         /\.\s*[a-zA-Z]{4,}\s+[a-zA-Z]{1,}\./.match(parsed_namae.given)
        return default
      end

      if parsed_namae.display_order =~ @blacklist
        return default
      end

      if parsed_namae.family &&
         parsed_namae.family.count(".") == 1 &&
         parsed_namae.family[-1] == "." &&
         parsed_namae.family.length > 3
        parsed_namae.family = parsed_namae.family.delete_suffix(".")
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

      if !parsed_namae.given &&
         parsed_namae.particle &&
         parsed_namae.family &&
         /^[A-Za-z]{3,}\s+(?:[A-Z]\.\s?){1,}$/.match(parsed_namae.family)
         matched = /^(?<family>[A-Za-z]{3,})\s+(?<given>([A-Z]\.\s?){1,})$/.match(parsed_namae.family)
         parsed_namae.family = matched[:family]
         parsed_namae.given = matched[:given]
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

      if parsed_namae.family &&
         @family_blacklist.any?{ |s| s.casecmp(parsed_namae.family) == 0 }
        return default
      end

      if parsed_namae.family.nil? &&
         !parsed_namae.given.nil? &&
         !parsed_namae.given.include?(".")
        parsed_namae.family = parsed_namae.given
        parsed_namae.given = nil
      end

      parsed_namae.normalize_initials

      family = parsed_namae.family
      given = parsed_namae.given.strip rescue nil
      particle = parsed_namae.particle.strip rescue nil
      appellation = parsed_namae.appellation.strip rescue nil
      suffix = parsed_namae.suffix.strip rescue nil
      title = parsed_namae.title.strip rescue nil

      if !given.nil? && given.match(/[A-Z]\.[A-Za-z]{2,}/)
        given = given.gsub(".", ". ").strip
      end

      if !family.nil? &&
         given.nil? &&
         !particle.nil? &&
         !@particles.include?(particle.downcase)
        given = particle.sub(/[a-z]\./, &:upcase).sub(/^(.)/) { $1.capitalize }
        particle = nil
      end

      if !particle.nil? && particle.include?(".") && !particle.include?("v")
        particle = nil
      end

      if !family.nil? && (family == family.upcase || family == family.downcase)
        family = NameCase(family)
      end

      if !family.nil? && family.match(/[A-Z]{1,3}$/)
        family = NameCase(family.upcase)
      end

      if given.nil? && !family.nil? && family.match(/^[A-Z]{2}/)
        return default
      end

      if !family.nil? && @family_blacklist.any?{ |s| s.casecmp(family) == 0 }
        return default
      end

      if !given.nil? && @given_blacklist.any?{ |s| s.casecmp(given) == 0 }
        return default
      end

      if !family.nil? && family.downcase.count(VOWELS) == 0 &&
         !FAMILY_GREENLIST.any?{ |s| s.casecmp(family) == 0 }
       return default
      end

      name = {
        title: title,
        appellation: appellation,
        given: given,
        particle: particle,
        family: family,
        suffix: suffix,
        nick: parsed_namae.nick,
        dropping_particle: parsed_namae.dropping_particle
      }
      Namae::Name.new(name)
    end

  end

end
