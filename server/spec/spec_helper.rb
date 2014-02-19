ENV["RACK_ENV"] ||= 'test'
require_relative '../bootstrap'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.join(File.dirname(__FILE__), "support/**/*.rb")].sort.each { |f| require f }

RSpec.configure do |config|
  config.order = "random"
end
