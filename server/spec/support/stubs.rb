module StubSpecHelpers
  def semaphore_build_url
    "https://semaphoreapp.com/api/v1/projects/6cd846702948d8924c03d921844f8143f30215fa/91845/status?auth_token=YOURAUTHTOKEN"
  end
end

RSpec.configure do |config|
  config.include StubSpecHelpers
end
