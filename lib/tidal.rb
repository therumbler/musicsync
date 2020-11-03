require 'net/http'
require 'json'

module Tidal
    TOKEN = ENV["TIDAL_TOKEN"]
    def Tidal.call(endpoint, params)
        url = "https://api.tidalhifi.com/v1/#{endpoint}"
        uri = URI(url)
        params["countryCode"] = "CA"
        params["token"] = TOKEN
        uri.query = URI.encode_www_form(params)
        puts "fetching", uri
        resp = Net::HTTP.get_response(uri)
        resp_hash = JSON.parse(resp.body)
        if Integer(resp.code) >= 400
            raise StandardError.new "resp error from #{uri} : #{resp.body} "
        end
        
        # puts resp_hash
    end

    def Tidal.search(query)
        return call('search', {:query=>query})
    end
end