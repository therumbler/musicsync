require 'socket'
require 'digest/sha1'

$WS_CONSTANT = "258EAFA5-E914-47DA-95CA-C5AB0DC85B11"

module Server
    # based on https://www.honeybadger.io/blog/building-a-simple-websockets-server-from-scratch-in-ruby/

    def read_request(socket)
         # Read the HTTP request. We know it's finished when we see a line with nothing but \r\n
         http_request = ""
         while (line = socket.gets) && (line != "\r\n")
             http_request += line
         end
        #  STDERR.puts "Incoming Request"
        #  STDERR.puts http_request
        return http_request
    end

    def parse_websocket_headers(http_request)
        if matches = http_request.match(/^Sec-WebSocket-Key: (\S+)/)
            websocket_key = matches[1]
            STDERR.puts "Websocket handshake detected with key: #{ websocket_key }"
        else
            STDERR.puts "Aborting non-websocket connection"
            return
        end
        response_key = Digest::SHA1.base64digest([websocket_key, $WS_CONSTANT].join)
        return <<-eos
HTTP/1.1 101 Switching Protocols
Upgrade: websocket
Connection: Upgrade
Sec-WebSocket-Accept: #{ response_key }

        eos
    end
    def parse_websocket_message(socket)
        first_byte = socket.getbyte
        fin = first_byte & 0b10000000
        opcode = first_byte & 0b00001111
        
        raise "We don't support continuations" unless fin
        raise "We only support opcode 1" unless opcode == 1
        
        second_byte = socket.getbyte
        is_masked = second_byte & 0b10000000
        payload_size = second_byte & 0b01111111

        raise "All incoming frames should be masked according to the websocket spec" unless is_masked
        raise "We only support payloads < 126 bytes in length" unless payload_size < 126
        
        mask = 4.times.map { socket.getbyte }
        data = payload_size.times.map { socket.getbyte }
        unmasked_data = data.each_with_index.map { |byte, i| byte ^ mask[i % 4] }
        data_string = unmasked_data.pack('C*').force_encoding('utf-8').inspect
    end

    def run_server
        STDERR.puts "running server..."
        server = TCPServer.new('0.0.0.0', 2345)
        loop do
            # Wait for a connection
            socket = server.accept
            http_request = read_request(socket)
            # STDERR.puts "http_request #{http_request}"
            response = parse_websocket_headers(http_request)
            if response
                STDERR.puts("writing output #{response}")
                socket.write (response)
            else
                STDERR.puts "no response to write"
                socket.close
                next
            end
            loop do
                message = parse_websocket_message(socket)
                STDERR.puts "got message #{message}"
            end
            STDERR.puts "end of loop"
        end
    end
end