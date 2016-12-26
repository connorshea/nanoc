module Nanoc::Int
  # Stores checksums for objects in order to be able to detect whether a file
  # has changed since the last site compilation.
  #
  # @api private
  class ChecksumStore < ::Nanoc::Int::Store2
    include Nanoc::Int::ContractsSupport

    attr_accessor :objects

    c_obj = C::Or[Nanoc::Int::Item, Nanoc::Int::Layout, Nanoc::Int::Configuration, Nanoc::Int::CodeSnippet]

    contract C::KeywordArgs[site: C::Maybe[Nanoc::Int::Site], objects: C::IterOf[c_obj]] => C::Any
    def initialize(site: nil, objects:)
      super(Nanoc::Int::Store.tmp_path_for(env_name: (site.config.env_name if site), store_name: 'checksums'), 1)

      @objects = objects
    end

    def [](obj)
      db_get(key_for(obj))
    end

    contract c_obj => self
    def add(obj)
      if obj.is_a?(Nanoc::Int::Document)
        db_set(content_key_for(obj), Nanoc::Int::Checksummer.calc_for_content_of(obj))
        db_set(attributes_key_for(obj), Nanoc::Int::Checksummer.calc_for_attributes_of(obj))
      end

      db_set(key_for(obj), Nanoc::Int::Checksummer.calc(obj))

      flush

      self
    end

    contract c_obj => C::Maybe[String]
    def content_checksum_for(obj)
      db_get(content_key_for(obj))
    end

    contract c_obj => C::Maybe[String]
    def attributes_checksum_for(obj)
      db_get(attributes_key_for(obj))
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
