class Settings < Settingslogic
  if ENVIRONMENT == "test"
    source File.join(File.dirname(__FILE__), "application.yml.example")
  else
    source File.join(File.dirname(__FILE__), "application.yml")
  end

  namespace ENVIRONMENT
end
