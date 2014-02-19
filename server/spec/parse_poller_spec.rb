require_relative 'spec_helper'

describe ParsePoller do
  describe "#do_something" do
    subject { ParsePoller.new }
    it { should be_true }
  end
end
