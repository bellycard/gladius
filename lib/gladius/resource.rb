require "ostruct"

module Gladius
  # A class which enables us to pleasantly interact with jsonapi documents.
  class Resource
    attr_accessor :_agent, :_new, :data, :type, :id

    def initialize(data = {}, agent:, new: true)
      @type, @id, attrs = *data.values_at(:type, :id, :attributes)
      @data = OpenStruct.new(attrs)
      @_agent = agent
      @_new = new
    end

    def to_jsonapi_hash
      attributes = @data.dup
      { data: {
        id: (_new ? nil : id),
        type: type,
        attributes: attributes.to_h
      }.compact }
    end

    def save!
      if _new
        _agent.create(self)
      else
        _agent.update(self)
      end
    end

    def respond_to_missing?(meth, *_args, &_block)
      @data.respond_to?(meth) || /=$/.match?(meth)
    end

    def method_missing(meth, *args, &block)
      super unless respond_to_missing?(meth, *args, &block)
      @data.send(meth, *args, &block)
    end

    def to_s
      attributes = data.dup.to_h.to_a
      length = attributes.map(&:first).max_by(&:length).length
      print "#{type[0].upcase}#{type[1..-1]}: #{id}\n"
      attributes.map{|d| [length] + d}.each do |attr|
        print format("%*s: %s", *attr) + "\n"
      end
      nil
    end
  end
end