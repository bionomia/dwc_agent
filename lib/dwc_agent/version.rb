module DwcAgent

  class Version

    MAJOR = 3
    MINOR = 4
    PATCH = 0
    BUILD = 0

    def self.version
      [MAJOR, MINOR, PATCH, BUILD].compact.join('.').freeze
    end

    def self.date
      '2025-08-20'
    end

  end

end