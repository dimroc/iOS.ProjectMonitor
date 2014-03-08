ENV["RACK_ENV"] ||= 'test'
require_relative '../bootstrap'

require_all "spec/fakes"
require_all "spec/support"

RSpec.configure do |config|
  config.order = "random"
end
