require 'sinatra/base'

class FakePusher < Sinatra::Base
  post "/apps/:app_id/events", provides: :json do
    JSON.parse(request.body.read)
    {}.to_json
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
