module Phase8
  class Flash
    attr_reader :requests, :now

    def initialize(req)
      req.cookies.each do |cookie|
        if cookie.name == '_rails_lite_app_flash'
          @cookie_req = JSON.parse(cookie.value)
          break
        end
      end
      @cookie_req ||= {}
      @cookie_res = {}
      @now = {}
    end

    def [](key)
      @cookie_req[key.to_s] || @cookie_res[key.to_s] || @now[key]
    end

    def []=(key, value)
      @cookie_res[key.to_s] = value
    end

    def store_flash(res)
      cookie = WEBrick::Cookie.new('_rails_lite_app_flash', (@cookie_res).to_json )
      res.cookies << cookie
    end

    def now
      @now
    end

  end
end

# flash.now[:lol] = "ha"
