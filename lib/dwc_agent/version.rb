module DwcAgent

  class Version

    MAJOR = 3
    MINOR = 4
    PATCH = 3
    BUILD = 0

    def self.version
      [MAJOR, MINOR, PATCH, BUILD].compact.join('.').freeze
    end

    def self.date
      '2026-02-23'
    end

  end

end