require 'spec_helper'

describe UpdateBuildWorker do
  describe "unique jobs" do
    before { Sidekiq::Testing.fake! }
    after(:each) do
      sleep 1
      puts "clearing #{UpdateBuildWorker.jobs.size}"
      Sidekiq::Worker.clear_all
      UpdateBuildWorker.jobs.clear
    end

    context "with two builds with the same objectId" do
      let(:build1) { new_parse_build.merge("objectId" => "1") }
      let(:build2) { new_parse_build.merge("objectId" => "1")}

      it "should only enqueue one job" do
        expect {
          UpdateBuildWorker.perform_async(build1)
          UpdateBuildWorker.perform_async(build2)
        }.to change(UpdateBuildWorker.jobs, :size).by(1)
      end
    end

    context "with different objectIds" do
      let(:build1) { new_parse_build.merge("objectId" => "1") }
      let(:build2) { new_parse_build.merge("objectId" => "2")}

      it "should enqueue both jobs" do
        expect {
          UpdateBuildWorker.perform_async(build1)
          UpdateBuildWorker.perform_async(build2)
        }.to change { UpdateBuildWorker.jobs.size }.by(2)
      end
    end
  end

  describe "#perform" do
    let(:build) { new_parse_build }
    it "should update the build" do
      BuildFetcher.any_instance.should_receive(:fetch).and_return(build)
      ParseClient.any_instance.should_receive(:update).with(build)
      UpdateBuildWorker.new.perform(build)
    end

    context "when services are healthy" do
      # unable to create a semaphore test server with expected builds
      # so force fakes here
      before { servers_return_healthy }
      let(:client) { ParseClient.from_settings }

      it "should update the build" do
        client.fetch_builds.should be_empty
        created_build = client.create(build)
        UpdateBuildWorker.new.perform(created_build)
        client.fetch_builds.count.should == 1
      end
    end

    context "when services are erroring" do
      before { servers_return_error }
      it "should raise the error" do
        expect {
          UpdateBuildWorker.new.perform(build)
        }.to raise_error
      end
    end
  end
end
