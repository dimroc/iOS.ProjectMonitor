require 'spec_helper'

describe ParseClient do
  let(:client) { ParseClient.from_settings }

  describe "#fetch_builds" do
    context "when services are healthy" do
      context "and there are builds" do
        before { client.create(new_parse_build) }

        it "should return builds" do
          builds = client.fetch_builds
          first = builds.first
          first["project"].acts_like? "string"
          first.url.should =~ /\.com/
          first.startedAt["__type"].should == "Date"
        end
      end
    end

    context "when services are erroring" do
      before { servers_return_error }
      it "should raise error" do
        expect { client.fetch_builds }.to raise_error StandardError
      end
    end

    context "when services are unauthorized" do
      before { servers_return_unauthorized }
      it "should raise error" do
        expect { client.fetch_builds }.to raise_error StandardError
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

        updated_build = client.fetch_builds.detect do |b|
          b.objectId == build.objectId
        end

        updated_build.should be
        updated_build.project.should == "NewProjectName"
      end

      context "when the build to update no longer exists" do
        it "should error" do
          build.objectId = "NOTREAL"
          expect {
            client.update(build)
          }.to raise_error
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
end
