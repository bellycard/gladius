# frozen_string_literal: true
require "spec_helper"

module Gladius
  RSpec.describe(Resource) do
    let(:data_document) do
      {
        type: "potatoes",
        id: 12,
        attributes: {
          spots: 4,
          name: "Spudley"
        }
      }
    end
    let(:mock_agent) { double(:agent, update: nil, create: nil) }

    describe "Basics" do
      it "supports initialization with a data document" do
        resource = Resource.new(data_document, agent: mock_agent)
        expect(resource.type).to eq("potatoes")
        expect(resource.spots).to eq(4)
        expect(resource.name).to eq("Spudley")
      end

      it "can be converted back into a data document" do
        resource = Resource.new(data_document, agent: mock_agent, new: false)
        jsonified = resource.to_jsonapi_hash
        expect(jsonified[:data]).to eq(data_document)
      end
    end

    describe "Updating a resource" do
      it "patches the update into the system" do
        resource = Resource.new(data_document, agent: mock_agent, new: false)
        resource.name = "Brotato"
        resource.save!
        expect(mock_agent).to have_received(:update).with(resource)
      end
    end

    describe "Creating a resource" do
      it "posts the new model into the system" do
        resource = Resource.new(agent: mock_agent)
        resource.type = "potatoes"
        resource.name = "Glados"
        resource.spots = 2
        resource.save!
        expect(mock_agent).to have_received(:create).with(resource)
      end
    end
  end
end
