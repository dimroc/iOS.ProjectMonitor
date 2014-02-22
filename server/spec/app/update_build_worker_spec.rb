require 'spec_helper'

describe UpdateBuildWorker do
  describe "#perform" do
    it "should create the a build fetcher" do
      build = {"project" => "test build"}
      fetcher = double
      BuildFetcher.should_receive(:create).with(build).and_return(fetcher)
      fetcher.should_receive(:refresh)
      UpdateBuildWorker.new.perform(build)
    end
  end
end
