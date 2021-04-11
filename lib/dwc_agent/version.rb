module DwcAgent
  class Version

    MAJOR = 2
    MINOR = 0
    PATCH = 0
    BUILD = 1

    def self.version
      [MAJOR, MINOR, PATCH, BUILD].compact.join('.').freeze
    end

  end
end
