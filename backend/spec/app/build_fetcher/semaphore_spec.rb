require 'spec_helper'

describe BuildFetcher::Semaphore do
  describe "#parse" do
    let(:fetcher) { described_class.new({}) }
    let(:content) { FixtureLoader.load("semaphore_build") }
    it "should successfully parse json from semaphore" do
      parsed = fetcher.parse(content)
      parsed.project.should == "project_monitor"
    end
  end

  describe "#fetch" do
    let(:fetcher) { BuildFetcher::Semaphore.new(build) }
    let(:build) { saved_parse_build }

    context "when services are healthy" do
      # Force Fakes even in integration because we are unable to
      # configure an actual semaphore test server
      before { servers_return_healthy }
      it "assigns the parse variables to the updated build" do
        build.user.should be
        build.objectId.should be

        updated = fetcher.fetch
        updated.objectId.should == build.objectId
        updated.user.should == build.user
      end
    end

    context "when not found" do
      before do
        allow_any_instance_of(BuildFetcher::Semaphore).to receive(:puts)
        allow(fetcher).to receive(:retrieve_from_url).and_raise(BuildFetcher::NotFoundError)
      end

      it "should delete the build" do
        updated = fetcher.fetch
        updated.isInvalid.should == true
        updated.invalidMessage.should == "Not Found"
      end
    end
  end
end
