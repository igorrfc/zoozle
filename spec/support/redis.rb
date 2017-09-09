RSpec.configure do |config|
  config.before(:each) { $redis.flushdb }
  config.after(:each) { $redis.quit }
end
