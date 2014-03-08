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

    context "for nil" do
      let(:value) { nil }
      it { should == nil }
    end
  end

  describe ".merge" do
    subject { ParseBuild.merge(original, updated) }
    context "when the original has passed" do
      let(:original) { new_parse_build.merge("status" => "passed") }

      context "and the updated is pending" do
        let(:updated) { new_parse_build.merge("status" => "pending") }
        its(["status"]) { should == "passed-pending" }
      end

      context "and the updated is failed" do
        let(:updated) { new_parse_build.merge("status" => "failed") }
        its(["status"]) { should == "failed" }
      end

      context "and the updated is passed" do
        let(:updated) { new_parse_build.merge("status" => "passed") }
        its(["status"]) { should == "passed" }
      end
    end

    context "when the original is pending" do
      let(:original) { new_parse_build.merge("status" => "pending") }

      context "and the updated is pending" do
        let(:updated) { new_parse_build.merge("status" => "pending") }
        its(["status"]) { should == "pending" }
      end

      context "and the updated is failed" do
        let(:updated) { new_parse_build.merge("status" => "failed") }
        its(["status"]) { should == "failed" }
      end

      context "and the updated is passed" do
        let(:updated) { new_parse_build.merge("status" => "passed") }
        its(["status"]) { should == "passed" }
      end
    end

    context "when the original has failed" do
      let(:original) { new_parse_build.merge("status" => "failed") }

      context "and the updated is pending" do
        let(:updated) { new_parse_build.merge("status" => "pending") }
        its(["status"]) { should == "failed-pending" }
      end

      context "and the updated is failed" do
        let(:updated) { new_parse_build.merge("status" => "failed") }
        its(["status"]) { should == "failed" }
      end

      context "and the updated is passed" do
        let(:updated) { new_parse_build.merge("status" => "passed") }
        its(["status"]) { should == "passed" }
      end
    end

    context "when the original is passed-pending" do
      let(:original) { new_parse_build.merge("status" => "passed-pending") }

      context "and the updated is pending" do
        let(:updated) { new_parse_build.merge("status" => "pending") }
        its(["status"]) { should == "passed-pending" }
      end

      context "and the updated is failed" do
        let(:updated) { new_parse_build.merge("status" => "failed") }
        its(["status"]) { should == "failed" }
      end

      context "and the updated is passed" do
        let(:updated) { new_parse_build.merge("status" => "passed") }
        its(["status"]) { should == "passed" }
      end
    end
  end
end
