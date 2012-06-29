require 'rubygems'
require 'action_view'
require 'time'
#require 'active_support/core_ext/numeric/time'
#require 'dotiw'
include ActionView::Helpers::DateHelper

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
            time_human = distance_of_time_in_words(Time.at(last_build['timestamp'] / 1000), Time.now) 
            time_human = time_human.gsub(/^about\s+/, '')
            return { 
                :job => last_build["fullDisplayName"],
                :health => health,
                :committers => committers,
                :building => last_build["building"],
                :status => status,
                :duration => duration,
                :progress => progress,
                :failures => fail_count,
                :timestamp => last_build["timestamp"],
                :time_human => time_human + ' ago',
                :comments => comments 
            }
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
            current_duration = time_building
            hours = current_duration / 3600
            minutes = (current_duration % 3600) / 60
            seconds = (current_duration % 60)
            #format("%02d:%02d:%02d", hours, minutes, seconds)
            format("%d:%02d:%02d", hours, minutes, seconds)
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
            current_duration = time_building
            return 0.0 if duration.nil? || duration == 0 || current_duration == 0
            return 100 * current_duration / (duration / 1000)
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
