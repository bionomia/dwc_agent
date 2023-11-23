module DwcAgent

  class Version

    MAJOR = 3
    MINOR = 0
    PATCH = 16
    BUILD = 1

    def self.version
      [MAJOR, MINOR, PATCH, BUILD].compact.join('.').freeze
    end

  end

end