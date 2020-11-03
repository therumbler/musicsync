#!/usr/bin/env ruby
$LOAD_PATH << '.'
require 'lib/tidal'
include Tidal
puts Tidal.search('quincy')