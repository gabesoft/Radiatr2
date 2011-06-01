class JenkinsConnector
  def latest_build config
    full_data = fetch_full_data config["url"]
    data = fetch_data config["url"]
    { :job => data["fullDisplayName"], :project => config["project"], :health => health_from_data(full_data),
      :committers => committers_from_data(data), :building => data["building"], :status => status_from_data(data, full_data) }
  end

  def status_from_data data, full_data
    return data["result"] if data["result"]
    data = fetch_full_data full_data["builds"][0]["url"]
    data["result"]
  end

  def health_from_data full_data
    full_data["healthReport"][0]["score"]
  end

  def committers_from_data data
    data["changeSet"]["items"][0]["user"] if data["changeSet"]["items"].size > 0
  end

  def fetch_full_data url
    JSON.parse Net::HTTP.get URI.parse(url + '/api/json')
  end

  def fetch_data url
    JSON.parse Net::HTTP.get URI.parse(url + '/lastBuild/api/json')
  end

  def connector; "Jenkins"; end
end
