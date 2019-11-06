module DwcAgent
  class Version

    MAJOR = 1
    MINOR = 3
    PATCH = 1
    BUILD = nil

    def self.version
      [MAJOR, MINOR, PATCH, BUILD].compact.join('.').freeze
    end

  end
end
