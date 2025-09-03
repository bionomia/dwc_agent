module DwcAgent

  class Version

    MAJOR = 3
    MINOR = 4
    PATCH = 1
    BUILD = 0

    def self.version
      [MAJOR, MINOR, PATCH, BUILD].compact.join('.').freeze
    end

    def self.date
      '2025-09-03'
    end

  end

end