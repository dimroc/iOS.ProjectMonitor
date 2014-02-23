require 'spec_helper'

describe UpdateBuildWorker do
  describe "#perform" do
    it "should create the build fetcher" do
      build = {"project" => "test build", "type" => "SemaphoreBuild" }
      BuildFetcher.any_instance.should_receive(:fetch).and_return(build)
      ParseClient.any_instance.should_receive(:save).with(build)
      UpdateBuildWorker.new.perform(build)
    end
  end
end
