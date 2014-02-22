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

  describe "#refresh" do
    let(:fetcher) { BuildFetcher.new(build) }

    context "with a good uri" do
      let(:build) { {"url" => semaphore_build_url} }

      context "when services are healthy" do
        it "should raise not implemented error" do
          expect {
            fetcher.refresh
          }.to raise_error NotImplementedError
        end
      end

      context "when services are erroring" do
        before { servers_return_error }

        it "should raise not implemented error" do
          expect {
            fetcher.refresh
          }.to raise_error StandardError
        end
      end

      context "when services are unauthorized" do
        before { servers_return_unauthorized }

        it "should raise not implemented error" do
          expect {
            fetcher.refresh
          }.to raise_error StandardError
        end
      end
    end

    context "with a bad uri" do
      let(:build) { {} }

      it "should raise not implemented error" do
        expect {
          fetcher.refresh
        }.to raise_error URI::InvalidURIError
      end
    end
  end
end
