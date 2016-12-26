module Nanoc::Int
  # Stores checksums for objects in order to be able to detect whether a file
  # has changed since the last site compilation.
  #
  # @api private
  class ChecksumStore
    include Nanoc::Int::ContractsSupport

    attr_accessor :objects

    c_obj = C::Or[Nanoc::Int::Item, Nanoc::Int::Layout, Nanoc::Int::Configuration, Nanoc::Int::CodeSnippet]

    contract C::KeywordArgs[site: C::Maybe[Nanoc::Int::Site], objects: C::IterOf[c_obj]] => C::Any
    def initialize(site: nil, objects:)

      @store = Nanoc::Int::Store2.new(
        Nanoc::Int::Store.tmp_path_for(
          env_name: (site.config.env_name if site),
          store_name: 'checksums',
        ),
        2,
      )

      @objects = objects
    end

    def load
      # do nothing
    end

    def store
      @store.flush
    end

    def [](obj)
      @store[key_for(obj)]
    end

    contract c_obj => self
    def add(obj)
      if obj.is_a?(Nanoc::Int::Document)
        @store[content_key_for(obj)] = Nanoc::Int::Checksummer.calc_for_content_of(obj)
        @store[attributes_key_for(obj)] = Nanoc::Int::Checksummer.calc_for_attributes_of(obj)
      end

      @store[key_for(obj)] = Nanoc::Int::Checksummer.calc(obj)

      @store.flush

      self
    end

    contract c_obj => C::Maybe[String]
    def content_checksum_for(obj)
      @store[content_key_for(obj)]
    end

    contract c_obj => C::Maybe[String]
    def attributes_checksum_for(obj)
      @store[attributes_key_for(obj)]
    end

    private

    def content_key_for(obj)
      'content_' + obj.reference.inspect
    end

    def attributes_key_for(obj)
      'attributes_' + obj.reference.inspect
    end

    def key_for(obj)
      'all_' + obj.reference.inspect
    end
  end
end
