RSpec.configure do |config|
  config.before(:each) do
    Redis::Semaphore.any_instance.stub(:lock).and_yield
  end
end
