require 'spec_helper'

describe PusherClient do
  describe "#push" do
    let(:pusher) { PusherClient.from_settings }
    it "should successfully push to service" do
      pusher.push("FakeUserId", {key: "value"})
    end
  end
end
