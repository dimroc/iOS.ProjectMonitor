module StubSpecHelpers
  def semaphore_build_url
    "https://semaphoreapp.com/api/v1/projects/6cd846702948d8924c03d921844f8143f30215fa/91845/status?auth_token=YOURAUTHTOKEN"
  end

  def broken_build
    build = new_parse_build
    output = build.output
    build.stub(:output).and_return(output.except("type"))
    build
  end

  def new_parse_build
    saved_parse_build.except("objectId")
  end

  def saved_parse_build
    ParseBuild.new JSON.parse(FixtureLoader.load("parse_builds"))["results"].first
  end

  def random_id
    rand.to_s[2..11]
  end
end

RSpec.configure do |config|
  config.include StubSpecHelpers
end
