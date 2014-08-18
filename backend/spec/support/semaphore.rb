RSpec.configure do |config|
  config.before(:each) do
    allow_any_instance_of(Redis::Semaphore).to receive(:lock).and_yield
  end
end
