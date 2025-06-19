module DwcAgent

  class Version

    MAJOR = 3
    MINOR = 3
    PATCH = 1
    BUILD = 0

    def self.version
      [MAJOR, MINOR, PATCH, BUILD].compact.join('.').freeze
    end

    def self.date
      '2025-06-18'
    end

  end

end