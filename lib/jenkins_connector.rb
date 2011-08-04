class JenkinsConnector
  def latest_build config
    full_data = fetch_full_data config["url"]
    data = fetch_data config["url"]
    { :job => data["fullDisplayName"], :project => config["project"], 
      :health => health_from_data(full_data),
      :committers => committers_from_data(data), :building => data["building"], 
      :status => status_from_data(data, full_data),
      :duration => duration_from_data(data), 
      :progress => time_building_from_data(data),
      :failures => fail_count_from_data(data), 
      :comments => comments(data)}
  rescue => e
    puts e.inspect
    puts e.backtrace
    { :job => "Connection error" }
  end

  def comments data
    items = data['changeSet']['items']
    unless items.nil?
      comments = items.inject "" do |allComments, item|
        allComments += item["comment"] + ';'
      end 
      return comments.slice(0, 140)
    end  
    "No Comment (Forced)"
  end
  
  def status_from_data data, full_data
    return data["result"] if data["result"]
    data = fetch_full_data full_data["builds"][1]["url"]
    data["result"]
  end

  def health_from_data full_data
    full_data["healthReport"][0]["score"]
  end

  def committers_from_data data
    data["changeSet"]["items"][0]["user"] if data["changeSet"]["items"].size > 0
  end

  def duration_from_data data
    seconds = time_building_from_data(data)
    (seconds / 60).to_s + "m " + (seconds % 60).to_s + "s"
  end
  
  def time_building_from_data data
    return (((Time.now.to_f * 1000) - data["timestamp"]) / 1000).to_i if data["duration"] == 0
    data["duration"] / 1000
  end
  
  def fail_count_from_data data
    data["actions"].inject 0 do |sum, value|
      if value.has_key? "failCount" 
        sum + value["failCount"]
      else
        sum
      end
    end
  end

  def fetch_full_data url
    ::JSON.parse Net::HTTP.get URI.parse(url + '/api/json')
  end

  def fetch_data url
    ::JSON.parse Net::HTTP.get URI.parse(url + '/lastBuild/api/json')
  end

  def connector; "Jenkins"; end
end
