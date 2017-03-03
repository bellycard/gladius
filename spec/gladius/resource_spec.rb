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
    let(:mock_agent) { double(:agent, patch: nil) }

    describe "Basics" do
      it "supports initialization with a data document" do
        resource = Resource.new(data_document, mock_agent)
        expect(resource.type).to eq("potatoes")
        expect(resource.spots).to eq(4)
        expect(resource.name).to eq("Spudley")
      end

      it "can be converted back into a data document" do
        resource = Resource.new(data_document, mock_agent)
        jsonified = resource.to_jsonapi_hash
        expect(jsonified[:data]).to eq(data_document)
      end
    end

    describe "Updating a resource" do
      it "posts the update into the system" do
        resource = Resource.new(data_document, mock_agent)
        resource.name = "Brotato"
        resource.save!
        expect(mock_agent).to have_received(:patch).with(resource)
      end
    end
  end
end
