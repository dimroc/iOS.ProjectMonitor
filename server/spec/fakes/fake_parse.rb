require 'sinatra/base'

class FakeParse < Sinatra::Base
  get "/1/classes/Build", provides: :json do
    FixtureLoader.load("parse_builds")
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
