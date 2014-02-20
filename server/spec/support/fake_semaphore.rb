require 'sinatra/base'

class FakeSemaphore < Sinatra::Base
  get "/api/v1/projects/:hash_id/:id/status", provides: :json do
    erb = ERB.new(File.read(build_fixture))
    erb.result
  end

  private

  def build_fixture
    File.join(File.dirname(__FILE__), "../fixtures/semaphore_build.json.erb")
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
