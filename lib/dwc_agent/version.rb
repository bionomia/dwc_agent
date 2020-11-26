module DwcAgent
  class Version

    MAJOR = 1
    MINOR = 5
    PATCH = 1
    BUILD = 2

    def self.version
      [MAJOR, MINOR, PATCH, BUILD].compact.join('.').freeze
    end

  end
end
