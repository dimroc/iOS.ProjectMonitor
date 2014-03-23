class Settings < Settingslogic
  actual_settings = File.join(File.dirname(__FILE__), "application.yml")
  example_settings = File.join(File.dirname(__FILE__), "application.yml.example")

  if File.exists?(actual_settings)
    source actual_settings
  elsif ENVIRONMENT == "test"
    source example_settings
  else
    raise IOError, "Settings file 'application.yml' not found"
  end

  namespace ENVIRONMENT
end
