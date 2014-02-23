class ParseClient
  attr_reader :application_id, :master_key

  def self.from_settings
    new(Settings.parse_application_id, Settings.parse_master_key)
  end

  def initialize(application_id, master_key)
    @application_id = application_id
    @master_key = master_key
  end

  def fetch_builds
    response = HTTParty.get(builds_url, headers: headers)
    if response.code < 300
      response['results'].map { |value| ParseBuild.new value }
    else
      raise StandardError, "Error connecting to parse. Status: #{response.code} Message: #{response.message} #{response}"
    end
  end

  def save(build)
    puts "saving to parse: #{build}"
  end

  private

  def headers
    {
      'X-Parse-Application-Id' => Settings.parse_application_id,
      'X-Parse-Master-Key' => Settings.parse_master_key,
      'Content-Type' => 'application/json'
    }
  end

  def builds_url
    'https://api.parse.com/1/classes/Build'
  end
end
