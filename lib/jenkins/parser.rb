module Jenkins
  class Parser
    attr_reader :fetcher

    def initialize(fetcher)
      @fetcher = fetcher
    end

    def parse(data, full_data)
      { :job => data["fullDisplayName"],
        :health => health(full_data),
        :committers => committers(data),
        :building => data["building"],
        :status => status(data, full_data),
        :duration => duration(data),
        :progress => time_building(data),
        :failures => fail_count(data),
        :comments => comments(data) }
    end

    def status data, full_data
      return data["result"] if data["result"]
      data = fetcher.fetch(full_data["builds"][1]["url"] + '/api/json')
      data["result"]
    end

    def health full_data
      full_data["healthReport"][0]["score"]
    end

    def committers data
      data["changeSet"]["items"][0]["user"] if data["changeSet"]["items"].size > 0
    end

    def duration data
      seconds = time_building(data)
      (seconds / 60).to_s + "m " + (seconds % 60).to_s + "s"
    end

    def time_building data
      return (((Time.now.to_f * 1000) - data["timestamp"]) / 1000).to_i if data["duration"] == 0
      data["duration"] / 1000
    end

    def fail_count data
      data["actions"].inject 0 do |sum, value|
        if value.has_key? "failCount" 
          sum + value["failCount"]
        else
          sum
        end
      end
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
  end
end
