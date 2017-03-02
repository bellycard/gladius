# frozen_string_literal: true
require "spec_helper"
require "test_app"

RSpec.describe(Gladius) do
  let(:conn) { Faraday.new { |c| c.adapter :rack, Rails.application } }

  describe "Getting an Index of posts" do
    it "Allows me to use a cool API to get the index of posts and enumerate them" do
      3.times { Post.create! }
      agent = Gladius::Agent.new("http://localhost/posts", connection: conn)
      document_collection = agent.index

      expect(document_collection[:data].length).to eq(3)
    end
  end

  describe "Creating a new post, then viewing it" do
    it "Allows me to create a new post and view it" do
      agent = Gladius::Agent.new("http://localhost/posts", connection: conn)
      expect do
        post = agent.create!(title: "The title", body: "Body of post")
        post_id = post.dig(:data, :id)
        post = Post.find(post_id)
        expect(post.title).to eq("The title")
        expect(post.body).to eq("Body of post")
      end.to change(Post, :count).by(1)
    end
  end
end
