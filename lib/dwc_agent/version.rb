module DwcAgent
  class Version

    MAJOR = 2
    MINOR = 0
    PATCH = 1
    BUILD = 5

    def self.version
      [MAJOR, MINOR, PATCH, BUILD].compact.join('.').freeze
    end

  end
end
