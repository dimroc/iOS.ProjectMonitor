class FixtureLoader
  def self.load(fixture)
    fixture_content = File.join(File.dirname(__FILE__), "../fixtures/#{fixture}.json.erb")

    erb = ERB.new(File.read(fixture_content))
    erb.result
  end
end
