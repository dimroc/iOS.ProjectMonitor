require 'spec_helper'

describe BuildFetcher::Travis do
  describe "#parse" do
    let(:fetcher) { described_class.new({"project" => "best-org/monolithic_project"}) }
    let(:content) { JSON.parse(FixtureLoader.load("travis_build")) }
    it "should successfully parse json from travis" do
      parsed = fetcher.parse(content)
      parsed.branch.should == "release"
      parsed.commitAuthor.should == "Dimitri Roche"
    end
  end
end
