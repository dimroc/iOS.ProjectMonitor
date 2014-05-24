require 'spec_helper'

describe ParseClient do
  before { ParseClient.any_instance.stub(:puts) }
  let(:client) { ParseClient.from_settings }

  describe "#create" do
    context "when services are healthy" do
      it "should be able to create a build that has isInvalid true" do
        build = new_parse_build
        build.isInvalid = true
        build.invalidMessage = "Forbidden"

        created_build = client.create(build)
        build = client.fetch_valid_builds.last

        build.objectId.should == created_build.objectId
        build.invalidMessage.should == "Forbidden"
        build.isInvalid.should be_true
      end
    end
  end

  describe "#fetch_valid_builds" do
    context "when services are healthy" do
      context "and there are builds" do
        before { client.create(new_parse_build) }

        it "should return builds" do
          builds = client.fetch_valid_builds
          first = builds.first
          first["project"].acts_like? "string"
          first.url.should =~ /\.com/
          first.startedAt["__type"].should == "Date"
        end
      end

      context "and there is an invalid row" do
        before do
          client.create(broken_build)
        end

        it "should skip that build" do
          client.fetch_valid_builds.should be_empty
        end
      end
    end

    context "when services are erroring" do
      before { servers_return_error }
      it "should raise error" do
        expect { client.fetch_valid_builds }.to raise_error StandardError
      end
    end

    context "when services are unauthorized" do
      before { servers_return_unauthorized }
      it "should raise error" do
        expect { client.fetch_valid_builds }.to raise_error StandardError
      end
    end
  end

  describe "#update" do
    let(:build) { new_parse_build }

    context "when services are healthy" do
      it "should update the build on the service" do
        client.create(build)
        build.objectId.should be
        build.project.should_not == "NewProjectName"
        build.project = "NewProjectName"

        client.update(build)

        updated_build = client.fetch_valid_builds.detect do |b|
          b.objectId == build.objectId
        end

        updated_build.should be
        updated_build.project.should == "NewProjectName"
      end

      context "when the build to update no longer exists" do
        it "should error" do
          build.objectId = "NOTREAL"
          expect { client.update(build) }.to raise_error
        end
      end
    end

    context "when services are erroring" do
      before { servers_return_error }
      it "should error" do
        expect { client.update(build) }.to raise_error StandardError
      end
    end

    context "when services are unauthorized" do
      before { servers_return_unauthorized }
      it "should error" do
        expect { client.update(build) }.to raise_error StandardError
      end
    end
  end

  describe "#notify_build_failed" do
    before { ParseClient.any_instance.stub(:puts) }
    let(:build) { new_parse_build }
    context "when servers are healthy" do
      it "should return true" do
        response = client.notify_build_failed(build)
        response["result"].should be_true
      end
    end
  end
end
