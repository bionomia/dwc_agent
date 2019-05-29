module DwcAgent
  class Version

    MAJOR = 0
    MINOR = 2
    PATCH = 0

    def self.version
      [MAJOR, MINOR, PATCH, BUILD].compact.join('.').freeze
    end

  end
end
