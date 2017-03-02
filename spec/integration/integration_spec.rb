# frozen_string_literal: true
require "spec_helper"
require "test_app"

RSpec.describe("Gladius Integration") do
  describe "Getting an Index of posts" do
    it "Allows me to use a cool API to get the index of posts and enumerate them" do
      3.times { Post.create! }
      agent = Gladius::Agent.new("http://localhost/posts", connection: rack_faraday)
      document_collection = agent.index

      expect(document_collection[:data].length).to eq(3)
    end
  end

  describe "Working with single posts" do
    it "Allows me to create a new post and view it" do
      agent = Gladius::Agent.new("http://localhost/posts", connection: rack_faraday)
      expect do
        post = agent.create!(title: "The title", body: "Body of post")
        post_id = post.dig(:data, :id)
        post = Post.find(post_id)
        expect(post.title).to eq("The title")
        expect(post.body).to eq("Body of post")
      end.to change(Post, :count).by(1)
    end

    it "can fetch a post, and access its properties like methods" do
      agent = Gladius::Agent.new("http://localhost/posts", connection: rack_faraday)
      post = Post.create!(title: "Looks like a post", body: "Totally informative")
      post_resource = agent.get(post.id)
      expect(post_resource.id).to eq(post.id.to_s)
      expect(post_resource.title).to eq("Looks like a post")
      expect(post_resource.body).to eq("Totally informative")
    end

    it "can update a post" do
      agent = Gladius::Agent.new("http://localhost/posts", connection: rack_faraday)
      post = Post.create!(title: "Looks like a post", body: "Totally informative")
      post_resource = agent.get(post.id)
      post_resource.title = "Changed title"
      post_resource.save!
      post.reload
      expect(post.title).to eq("Changed title")
    end
  end
end
