require 'spec_helper'

describe ParseBuild do
  describe ".date_hash" do
    subject { ParseBuild.date_hash(value) }
    let(:date_string) { "2014-02-07T23:21:42Z" }

    context "for a string" do
      let(:value) { date_string }
      its(["__type"]) { should == "Date" }
      its(["iso"]) { should == date_string }
    end

    context "for a hash" do
      let(:value) do
        {
          "__type" => "Date",
          "iso" => "2014-02-07T23:21:42Z"
        }
      end

      its(["__type"]) { should == "Date" }
      its(["iso"]) { should == date_string }
    end
  end
end
