module DwcAgent
  class Version

    MAJOR = 0
    MINOR = 2
    PATCH = 2
    BUILD = nil

    def self.version
      [MAJOR, MINOR, PATCH, BUILD].compact.join('.').freeze
    end

  end
end
