# frozen_string_literal: true

# prepare active_record database
require "active_record"

ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")
# Uncomment if you need to see the activerecord logger output for the schema loadout.
# ActiveRecord::Base.logger = Logger.new(STDOUT)

ActiveRecord::Schema.define do
  # Add your schema here
  create_table :posts, force: true do |t|
    t.string :title
    t.string :body
  end
end

# create models
class Post < ActiveRecord::Base
end

# prepare rails app
require "action_controller/railtie"
# require 'action_view/railtie'
require "jsonapi-resources"

class ApplicationController < ActionController::Base
end

# prepare jsonapi resources and controllers
class PostsController < ApplicationController
  include JSONAPI::ActsAsResourceController
end

# posts resource
class PostResource < JSONAPI::Resource
  attribute :title
  attribute :body
end

# the core application
class TestApp < Rails::Application
  config.root = File.dirname(__FILE__)
  # Config stdout logger with a really bare bones formatter.
  config.logger = Logger.new(STDOUT,
                             formatter: ->(s, _, _, msg) { "#{s[0]} -- #{msg}\n" })
  ActiveRecord::Base.logger = config.logger
  config.log_level = :info

  ActiveRecord::Schema.verbose = false

  secrets.secret_token = "secret_token"
  secrets.secret_key_base = "secret_key_base"

  config.eager_load = false
end

# initialize app
Rails.application.initialize!

JSONAPI.configure do |config|
  config.json_key_format = :underscored_key
  config.route_format = :underscored_key
end

# routes
Rails.application.routes.draw do
  jsonapi_resources :posts
end


RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end