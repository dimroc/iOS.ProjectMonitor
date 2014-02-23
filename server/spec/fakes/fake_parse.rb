require 'sinatra/base'

class FakeParse < Sinatra::Base
  class << self
    def instances
      @instances ||= []
    end

    def reset
      instances.each(&:reset)
    end
  end

  def initialize
    self.class.instances << self
    reset
  end

  def reset
    @builds = {}
  end

  post "/1/classes/Build", provides: :json do
    body = JSON.parse(request.body.read)
    id = next_id
    date_string = Time.now.utc.iso8601
    @builds[id] = body.merge({
      "objectId" => id,
      "createdAt" => date_string,
      "updatedAt" => date_string
    })

    @builds[id].slice("createdAt", "objectId").to_json
  end

  get "/1/classes/Build", provides: :json do
    { "results" => @builds.values }.to_json
  end

  put "/1/classes/Build/:objectId", provides: :json do
    body = JSON.parse(request.body.read).with_indifferent_access
    raise Sinatra::NotFound unless @builds[params[:objectId]]
    @builds[params[:objectId]] = @builds[params[:objectId]].merge body
    { "updatedAt" => Time.now.utc.iso8601 }.to_json
  end

  private

  def next_id
    rand.to_s[2..11]
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
