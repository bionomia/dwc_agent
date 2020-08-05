module DwcAgent
  class Version

    MAJOR = 1
    MINOR = 4
    PATCH = 12
    BUILD = nil

    def self.version
      [MAJOR, MINOR, PATCH, BUILD].compact.join('.').freeze
    end

  end
end
