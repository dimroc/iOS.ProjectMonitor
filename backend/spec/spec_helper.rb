ENV["RACK_ENV"] ||= 'test'
require_relative '../bootstrap'

require_all "spec/fakes"

RSpec.configure do |config|
  config.order = "random"

  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
end

require_all "spec/support"
