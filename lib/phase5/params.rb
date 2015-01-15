require 'uri'
require 'byebug'

module Phase5
  class Params
    # use your initialize to merge params from
    # 1. query string
    # 2. post body
    # 3. route params
    #
    # You haven't done routing yet; but assume route params will be
    # passed in as a hash to `Params.new` as below:

    attr_reader :params

    def initialize(req, route_params = {})
      #debugger
      @req = req
      @route_params = route_params
      if @req.query_string
        @params = parse_www_encoded_form(req.query_string)
      else
        @params = {}
      end
      if @req.body
        @params.merge!(parse_www_encoded_form(req.body))
      end
      if @route_params
        @params.merge!(route_params)
      end
    end

    def [](key)
      @params[key.to_sym] || @params[key]
    end

    def to_s
      @params.to_json.to_s
    end

    class AttributeNotFoundError < ArgumentError; end;

    private
    # this should return deeply nested hash
    # argument format
    # user[address][street]=main&user[address][zip]=89436
    # should return
    # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
    def parse_www_encoded_form(www_encoded_form)
      key_vals = URI::decode_www_form(www_encoded_form)
      # keys = parse_key(key_vals[0..key_vals.length-2])
      # keys = parse_key(key_vals.first)
      hash = {}
      key_vals.each do |key_val|
        keys = parse_key(key_val.first)
        current_key = hash
        keys.each_with_index do |key, i|
          val = key_val.last
          if i == keys.length - 1
            current_key[key] = val
          else
            current_key[key] ||= {}
            current_key = current_key[key]
          end
        end
      end
      hash
    end

    # this should return an array
    # user[address][street] should return ['user', 'address', 'street']
    def parse_key(key)
      key.split(/\]\[|\[|\]/)
      # keys = []
      # key.each do |k|
      #   keys << k
      # end
      # keys
    end
  end
end
