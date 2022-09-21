module DwcAgent

  class Version

    MAJOR = 3
    MINOR = 0
    PATCH = 1
    BUILD = 2

    def self.version
      [MAJOR, MINOR, PATCH, BUILD].compact.join('.').freeze
    end

  end

end
