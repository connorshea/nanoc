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

    # Logic for building tmp path from active environment and store name
    # @api private
    contract C::KeywordArgs[env_name: C::Maybe[String], store_name: String] => String
    def self.tmp_path_for(env_name:, store_name:)
      File.join('tmp', env_name.to_s, store_name)
    end

    def db_get(key)
      db[key]
    end

    def db_set(key, value)
      db[key] = value
    end

    def load
      # do nothing
    end

    def store
      flush
    end

    private

    def flush
      if @_db
        @_db.close
        @_db = nil
        db
      end
    end

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
