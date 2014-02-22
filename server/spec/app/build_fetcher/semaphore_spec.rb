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
end
