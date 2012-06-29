module Jenkins
    class Parser
        attr_reader :fetcher

        def initialize(fetcher)
            @fetcher = fetcher
        end

        def builds
            @fetcher.fetch('/api/json')
        end

        def last_build
            @fetcher.fetch('/lastBuild/api/json')
        end

        def last_completed_build
            @fetcher.fetch('/lastCompletedBuild/api/json')
        end

        def parse
            { :job => last_build["fullDisplayName"],
              :health => health,
              :committers => committers,
              :building => last_build["building"],
              :status => status,
              :duration => duration,
              :progress => progress,
              :failures => fail_count,
              :timestamp => last_build["timestamp"],
              :comments => comments }
        end

        def status
            return last_build["result"] if last_build["result"]
            last_completed_build["result"]
        end

        def health
            builds["healthReport"][0]["score"]
        end

        def committers
            last_build["changeSet"]["items"][0]["user"] if last_build["changeSet"]["items"].size > 0
        end

        def duration
            seconds = time_building
            (seconds / 60).to_s + "m " + (seconds % 60).to_s + "s"
        end

        def time_building
            return seconds_since last_build["timestamp"].to_i if last_build["duration"] == 0
            last_build["duration"] / 1000
        end

        def seconds_since timestamp
            (((Time.now.to_f * 1000) - timestamp.to_i) / 1000).to_i
        end

        def progress
            duration = last_completed_build["duration"]
            building = time_building
            return 0.0 if duration.nil? || duration == 0 || building == 0
            return 100 * building / (duration / 1000)
        end

        def fail_count
            last_build["actions"].inject 0 do |sum, value|
                if value.has_key? "failCount" 
                    sum + value["failCount"]
                else
                    sum
                end
            end
        end

        def comments
            items = last_build['changeSet']['items']
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
