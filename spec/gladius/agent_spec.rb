require "spec_helper"

RSpec.describe(Gladius::Agent) do
  describe "#parse_uri" do
    it "Splits the URI into base and resource_name on initialization" do
      agent = Gladius::Agent.new("http://test.com/foobars")
      expect(agent.base_uri.to_s).to eq("http://test.com")
      expect(agent.endpoint).to eq("foobars")
    end
  end
end