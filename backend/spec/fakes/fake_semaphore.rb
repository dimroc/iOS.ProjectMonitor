require 'sinatra/base'

class FakeSemaphore < Sinatra::Base
  get "/api/v1/projects/:hash_id/:id/status", provides: :json do
    FixtureLoader.load("semaphore_build")
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
