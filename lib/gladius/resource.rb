require "ostruct"

module Gladius
  # A class which enables us to pleasantly interact with jsonapi documents.
  class Resource
    attr_accessor :_agent, :data, :type, :id

    def initialize(data, agent)
      @type, @id, attrs = *data.values_at(:type, :id, :attributes)
      @_agent = agent
      @data = OpenStruct.new(attrs)
    end

    def to_jsonapi_hash
      attributes = @data.dup
      { data: {
        id: id,
        type: type,
        attributes: attributes.to_h
      } }
    end

    def save!
      _agent.patch(self)
    end

    def respond_to_missing?(meth, *_args, &_block)
      @data.respond_to?(meth)
    end

    def method_missing(meth, *args, &block)
      super unless @data.respond_to?(meth)
      @data.send(meth, *args, &block)
    end
  end
end