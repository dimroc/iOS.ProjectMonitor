require 'sinatra/base'

class FakeParse < Sinatra::Base
  get "/1/classes/Build", provides: :json do
    erb = ERB.new(File.read(build_fixture))
    erb.result
  end

  private

  def build_fixture
    File.join(File.dirname(__FILE__), "../fixtures/build.json.erb")
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
