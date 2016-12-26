require 'dbm'

module Nanoc::Int
  class Store2
    include Nanoc::Int::ContractsSupport

    attr_reader :filename
    attr_reader :version

    def initialize(filename, version)
      @filename = filename
      @version  = version
    end

    def [](key)
      db[key]
    end

    def []=(key, value)
      db[key] = value
    end

    def flush
      if @_db
        @_db.close
        @_db = nil
        db
      end
    end

    private

    def db
      @_db ||= begin
        # TODO: check version
        # TODO: add after-load hook to allow pruning old data
        FileUtils.mkdir_p(File.dirname(filename))
        DBM.open(filename, 0666, DBM::WRCREAT)
      end
    end
  end
end
