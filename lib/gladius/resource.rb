require "ostruct"

module Gladius
  # A class which enables us to pleasantly interact with jsonapi documents.
  class Resource < OpenStruct
    attr_accessor :_agent
    def self.build(data, agent)
      type, id, attrs = data[:data].values_at(:type, :id, :attributes)
      resource = new(attrs.merge(id: id, type: type))
      resource._agent = agent
      resource
    end

    def to_jsonapi_hash
      attributes = @table.dup
      { data: {
        id: attributes.delete(:id),
        type: attributes.delete(:type),
        attributes: attributes
      } }
    end

    def save!
      _agent.patch(self)
    end
  end
end