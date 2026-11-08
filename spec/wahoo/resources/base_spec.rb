# frozen_string_literal: true

require "spec_helper"

RSpec.describe Wahoo::Resources::Base do
  let(:test_model) do
    Class.new(Wahoo::Models::Base) do
      property :id
      property :name
    end
  end

  let(:test_resource_class) do
    model = test_model
    Class.new(Wahoo::Resources::Base) do
      define_method(:list) do |**opts|
        paginate("/v1/things", model: model, root: "things", **opts)
      end
      define_method(:fetch) do |id|
        get_one("/v1/things/#{id}", model: model)
      end
    end
  end

  let(:connection) { Wahoo::Connection.new(access_token: "t") }
  let(:resource) { test_resource_class.new(connection) }

  describe "pagination" do
    it "returns models from a single page" do
      stub_request(:get, "https://api.wahooligan.com/v1/things")
        .with(query: { page: 1, per_page: 30 })
        .to_return(status: 200,
                   body: { "things" => [{ "id" => 1, "name" => "A" }] }.to_json)

      results = resource.list

      expect(results.size).to eq(1)
      expect(results.first).to be_a(test_model)
      expect(results.first.name).to eq("A")
    end

    it "follows multiple pages until an incomplete one" do
      stub_request(:get, "https://api.wahooligan.com/v1/things")
        .with(query: { page: 1, per_page: 2 })
        .to_return(status: 200,
                   body: { "things" => [{ "id" => 1 }, { "id" => 2 }] }.to_json)
      stub_request(:get, "https://api.wahooligan.com/v1/things")
        .with(query: { page: 2, per_page: 2 })
        .to_return(status: 200,
                   body: { "things" => [{ "id" => 3 }] }.to_json)

      results = resource.list(per_page: 2)

      expect(results.map(&:id)).to eq([1, 2, 3])
    end

    it "stops at the limit" do
      stub_request(:get, "https://api.wahooligan.com/v1/things")
        .with(query: { page: 1, per_page: 30 })
        .to_return(status: 200,
                   body: { "things" => [{ "id" => 1 }, { "id" => 2 }, { "id" => 3 }] }.to_json)

      results = resource.list(limit: 2)

      expect(results.size).to eq(2)
      expect(results.map(&:id)).to eq([1, 2])
    end

    it "returns empty array when there are no results" do
      stub_request(:get, "https://api.wahooligan.com/v1/things")
        .with(query: { page: 1, per_page: 30 })
        .to_return(status: 200, body: { "things" => [] }.to_json)

      expect(resource.list).to eq([])
    end
  end

  describe "get_one" do
    it "returns a single model" do
      stub_request(:get, "https://api.wahooligan.com/v1/things/5")
        .to_return(status: 200, body: { "id" => 5, "name" => "Single" }.to_json)

      result = resource.fetch(5)

      expect(result).to be_a(test_model)
      expect(result.name).to eq("Single")
    end
  end
end