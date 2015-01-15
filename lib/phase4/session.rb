require 'json'
require 'webrick'
require 'byebug'

module Phase4
  class Session
    # find the cookie for this app
    # deserialize the cookie into a hash
    attr_reader :cookie

    def initialize(req)
      req.cookies.each do |cookie|
        if cookie.name == '_rails_lite_app'
          @cookie = JSON.parse(cookie.value)
          break
        end
      end
      @cookie ||= {}
    end

    def [](key)
      @cookie[key]
    end

    def []=(key, val)
      # byebug
      @cookie[key] = val
    end

    # serialize the hash into json and save in a cookie
    # add to the responses cookies
    def store_session(res)
      cookie = WEBrick::Cookie.new('_rails_lite_app', (@cookie).to_json )
      res.cookies << cookie
    end
  end
end
