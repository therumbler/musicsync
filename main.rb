#!/usr/bin/env ruby
$LOAD_PATH << '.'
require 'lib/tidal'
require 'lib/models/track'
require 'lib/server'

include Tidal
include Models
include  Server

# results = Tidal.search('quincy')
# results["tracks"]["items"].each do |t|
#     # puts track[:title]
#     # puts track
#     puts t["title"]
#     track = Models::Track.new(t["title"], t["artists"])
# end
# puts results

Server.run_server