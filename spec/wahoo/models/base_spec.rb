# frozen_string_literal: true

require "spec_helper"

RSpec.describe Wahoo::Models::Base do

  let(:test_class) do
    Class.new(Wahoo::Models::Base) do
      property :name
      property :count
      property :started_at, as: :time
      property :birth_day, as: :date
      property :renamed, key: "original_key"
    end
  end

  describe "property" do
    it "exposes a field from the hash" do
      model = test_class.new("name" => "Morning Ride", "count" => 5)

      expect(model.name).to eq("Morning Ride")
      expect(model.count).to eq(5)
    end

    it "returns nil for a missing field" do
      model = test_class.new("name" => "x")
      expect(model.count).to be_nil
    end

    it "reads from a custom key when given" do
      model = test_class.new("original_key" => "the value")
      expect(model.renamed).to eq("the value")
    end

    it "converts to Time with as: :time" do
      model = test_class.new("started_at" => "2026-08-22T08:00:00Z")
      expect(model.started_at).to be_a(Time)
    end

    it "converts to Date with as: :date" do
      model = test_class.new("birth_day" => "1990-05-15")
      expect(model.birth_day).to be_a(Date)
    end
  end

  describe ".from" do
    it "builds a model from a hash" do
      model = test_class.from("name" => "Test")
      expect(model).to be_a(test_class)
      expect(model.name).to eq("Test")
    end

    it "returns nil when given nil" do
      expect(test_class.from(nil)).to be_nil
    end
  end

  describe ".from_list" do
    it "builds an array of models" do
      models = test_class.from_list([{ "name" => "A" }, { "name" => "B" }])

      expect(models.size).to eq(2)
      expect(models.map(&:name)).to eq(["A", "B"])
    end

    it "returns an empty array for nil" do
      expect(test_class.from_list(nil)).to eq([])
    end
  end

  describe "#raw" do
    it "keeps the original hash accessible" do
      data = { "name" => "x", "extra_field" => "something unmapped" }
      model = test_class.new(data)

      expect(model.raw).to eq(data)
      expect(model.raw["extra_field"]).to eq("something unmapped")
    end
  end

  describe "#[]" do
    it "accesses raw fields by key" do
      model = test_class.new("name" => "x")
      expect(model["name"]).to eq("x")
    end
  end
end