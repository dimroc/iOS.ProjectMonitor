require 'spec_helper'

describe BuildFetcher do
  describe ".create" do
    context "for a fetcher that exists" do
      before do
        class BuildFetcher::Test < BuildFetcher; end;
      end

      let(:build) { { "type" => "TestBuild" } }
      it "should create an instance" do
        instance = BuildFetcher.create(build)
        instance.should be
      end
    end

    context "for a fetcher that doesn't exist" do
      let(:build) { { "type" => "SomeNewBuild" } }
      it "should raise an error" do
        expect {
          BuildFetcher.create(build)
        }.to raise_error
      end
    end
  end

  describe "#fetch" do
    let(:fetcher) { BuildFetcher.new(build) }

    context "with a build with a good uri" do
      let(:build) { new_parse_build }

      context "when services are healthy" do
        # Force Fakes even in integration because we are unable to
        # configure an actual semaphore test server
        before { servers_return_healthy }

        it "should raise not implemented error" do
          expect {
            fetcher.fetch
          }.to raise_error NotImplementedError
        end
      end

      context "when services are erroring" do
        before { servers_return_error }

        it "should raise standard error" do
          expect {
            fetcher.fetch
          }.to raise_error StandardError
        end
      end

      context "when services are unauthorized" do
        before { servers_return_unauthorized }

        it "should raise standard error" do
          expect {
            fetcher.fetch
          }.to raise_error StandardError
        end
      end
    end

    context "with a bad uri" do
      let(:build) { saved_parse_build.merge({ "url" => "gibberish" })}

      it "should raise not implemented error" do
        expect {
          fetcher.fetch
        }.to raise_error StandardError
      end
    end
  end
end
