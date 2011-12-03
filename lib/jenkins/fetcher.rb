module Jenkins
  class Fetcher
    def initialize(user=nil, password=nil)
      @user = user
      @password = password
    end

    def fetch url
      get_uri URI.parse url
    end

    def get_uri uri
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Get.new(uri.request_uri)
      request.basic_auth(@user, @password) if has_login?
      ::JSON.parse http.request(request).body
    end

    def has_login?
      not @user.nil? and not @password.nil?
    end
  end
end
