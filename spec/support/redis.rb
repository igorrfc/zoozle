RSpec.configure do |config|
  config.before(:each) do
    stub_const('RedisDb::CONN', Redis.new)
    RedisDb::CONN.flushdb
  end

  config.after(:each) { RedisDb::CONN.quit }
end
