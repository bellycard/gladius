# frozen_string_literal: true
require "ostruct"
require "faraday"
require "addressable/uri"
require "addressable/template"
require "json"

module Gladius
  # This is the basic client agent.
  class Agent
    attr_reader :_conn, :uri

    def initialize(uri, connection: Faraday.new)
      @uri = Addressable::URI.parse(uri)
      @_conn = apply_headers(connection)
    end

    def index
      response = _conn.get(uri)
      check_response(response)
      handle_response(response)
    end

    def create!(attrs)
      type = uri.path.split("/").pop
      response = _conn.post(uri, { data: {
        type: type,
        attributes: attrs
      } }.to_json)
      check_response(response)
      handle_response(response)
    end

    def get(id)
      response = _conn.get(member_uri_template.expand(id: id))
      unless response.headers["Content-Type"] == "application/vnd.api+json"
        raise "Something Wrong"
      end
      check_response(response)
      handle_response(response)
    end

    def patch(resource)
      response = _conn.patch(member_uri_template.expand(id: resource.id), resource.to_jsonapi_hash.to_json)
      unless response.headers["Content-Type"] == "application/vnd.api+json"
        raise "Something Wrong"
      end
      check_response(response)
      handle_response(response)
    end

    private

    def check_response(response)
      ct = response.headers["Content-Type"]
      raise "Something Wrong" unless ct == "application/vnd.api+json"
    end

    def handle_response(response)
      parsed = JSON.parse(response.body, symbolize_names: true)
      raise "Error #{parsed}" if parsed.key?(:errors)
      case parsed[:data]
      when Array
        parsed[:data].map { |d| handle_data(d) }
      when Hash
        handle_data(parsed[:data])
      else
        raise "Don't know what this is"
      end
    end

    def handle_data(data)
      Resource.new(data, self)
    end

    def member_uri_template
      Addressable::Template.new(uri.dup.to_s + "/{id}")
    end

    def apply_headers(conn)
      conn.headers["Content-Type"] = "application/vnd.api+json"
      conn.headers["Accept"] = "application/vnd.api+json"
      conn
    end
  end
end
