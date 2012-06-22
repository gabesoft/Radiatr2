module Jenkins
  class Fetcher
    def initialize(url, user=nil, password=nil)
      @url = url
      @user = user
      @password = password
    end

    def fetch relative_url
      get_uri URI.parse(@url + relative_url)
    end

    def get_uri uri
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Get.new(uri.request_uri)
      request.basic_auth(@user, @password) if has_login?
      body = http.request(request).body
      body = body.gsub("", "")
      ::JSON.parse body
    end

    def has_login?
      not @user.nil? and not @password.nil?
    end
  end
end
