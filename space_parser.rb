require 'active_support/all'
require 'net/http'
require 'net/https'
require 'open-uri'
require 'redis'

require 'rest-client'
class SpaceParser

  def self.redis
    @@redis
  end
  
  def self.stored_data()
    last_count = @redis.get('people_in_space')
    # Old format:
    date_changed = @redis.get('date_changed')
    # New format:
    time_changed = @redis.get('time_changed')
    
    if time_changed == '' || time_changed.nil?
      if date_changed != '' && date_changed != nil
        time_changed = Time.zone.parse(date_changed+'T23:59:59+0000')
      end
    else
      time_changed = Time.zone.parse(time_changed)
    end
    [time_changed, last_count]
  end
  
  def self.fetch_data()  
    if ENV['REDISTOGO_URL'] 
      uri = URI.parse(ENV['REDISTOGO_URL'])
      @redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
    else
      @redis = Redis.new()
    end

    Time.zone = 'UTC'

    time_changed, last_count = self.stored_data

    time_now = Time.zone.now

    feed = RestClient.get("http://howmanypeopleareinspacerightnow.com/space.json")
    people_in_space = JSON.parse(feed)
    count = people_in_space['number']
    
    is_new = false
    
    # time_changed will be nil the first time we run this.
    if time_changed != nil && time_now > time_changed && time_now <= (time_changed + 1.day)
      is_new = true
    elsif count.to_s != last_count.to_s
      @redis.set('people_in_space', count)
      @redis.set('time_changed', Time.zone.now.strftime('%Y-%m-%dT%H:%M:%S%z'))
      is_new = true
    end
  
    return [is_new, count]
  end
              
end
