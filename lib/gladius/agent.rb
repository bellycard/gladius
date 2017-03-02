# frozen_string_literal: true
require "ostruct"
require "faraday"
module Gladius
  # This is the basic client agent.
  class Agent
    attr_reader :_conn, :uri

    def initialize(uri, connection: Faraday.new)
      @uri = uri
      @_conn = apply_headers(connection)
    end

    def index
      response = _conn.get(uri)
      unless response.headers["Content-Type"] == "application/vnd.api+json"
        raise "Something Wrong"
      end
      JSON.parse(response.body, symbolize_names: true)
    end

    def create!(attrs)
      response = _conn.post(uri, { data: {
        type: "posts",
        attributes: attrs
      } }.to_json)
      unless response.headers["Content-Type"] == "application/vnd.api+json"
        raise "Something Wrong"
      end
      JSON.parse(response.body, symbolize_names: true)
    end

    private

    def apply_headers(conn)
      conn.headers["Content-Type"] = "application/vnd.api+json"
      conn.headers["Accept"] = "application/vnd.api+json"
      conn
    end
  end
end
