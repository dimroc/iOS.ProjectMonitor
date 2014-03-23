class PusherClient
  def self.from_settings
    PusherClient.new(Settings.pusher_app_id, Settings.pusher_key, Settings.pusher_secret)
  end

  attr_reader :client

  def initialize(app_id, key, secret)
    @client = Pusher::Client.new({
      app_id: app_id,
      key: key,
      secret: secret
    })

    client.encrypted = true
  end

  def push(user_object_id, build)
    client.trigger("user_#{user_object_id}", 'update_build', build)
  end
end
