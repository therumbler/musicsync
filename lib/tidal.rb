require 'net/http'
require 'json'

module Tidal
    TOKEN = ENV["TIDAL_TOKEN"]
    def Tidal.call(endpoint, params)
        # url = "https://api.tidalhifi.com/v1/search?query=quincy&countryCode=CA&token=hZ9wuySZCmpLLiui"
        url = "https://api.tidalhifi.com/v1/#{endpoint}?query"
        uri = URI(url)
        params["countryCode"] = "CA"
        params["token"] = TOKEN
        uri.query = URI.encode_www_form(params)
        puts "fetching", uri
        resp_string = Net::HTTP.get(uri)
        resp_hash = JSON.parse(resp_string)
        # puts resp_hash
    end

    def Tidal.search(query)
        return call('search', {:query=>"quincy"})
        # return Tidal.call("search")
    end
end