# frozen_string_literal: true

require "spec_helper"

RSpec.describe Wahoo::Resources::Uploads do
  let(:client) { Wahoo::Client.new(access_token: "fake_token") }

  describe "#create" do
    it "uploads a FIT file and returns a pending upload" do
      file = Tempfile.new(["workout", ".fit"])
      file.write("FIT_CONTENT")
      file.rewind

      stub = stub_request(:post, "https://api.wahooligan.com/v1/workout_file_uploads")
        .with { |req|
          body = JSON.parse(req.body)
          body["workout_file_upload"]["file"].start_with?("data:application/vnd.fit;base64,")
        }
        .to_return(status: 200,
                   body: { "id" => 1, "token" => "upload_token", "status" => "pending" }.to_json)

      upload = client.uploads.create(file: file.path, time_zone: "Europe/Bucharest")

      expect(upload).to be_a(Wahoo::Models::WorkoutFileUpload)
      expect(upload.status).to eq("pending")
      expect(upload.pending?).to be(true)
      expect(stub).to have_been_requested

      file.close
      file.unlink
    end
  end

  describe "#get" do
    it "checks the status of an upload by token" do
      stub_request(:get, "https://api.wahooligan.com/v1/workout_file_uploads/upload_token")
        .to_return(status: 200,
                   body: { "token" => "upload_token", "status" => "complete",
                           "workout_id" => 999 }.to_json)

      upload = client.uploads.get("upload_token")

      expect(upload.complete?).to be(true)
      expect(upload.workout_id).to eq(999)
    end

    it "recognizes an errored upload" do
      stub_request(:get, "https://api.wahooligan.com/v1/workout_file_uploads/bad_token")
        .to_return(status: 200,
                   body: { "token" => "bad_token", "status" => "error",
                           "error" => "corrupt file" }.to_json)

      upload = client.uploads.get("bad_token")

      expect(upload.error?).to be(true)
      expect(upload.error).to eq("corrupt file")
    end
  end
end