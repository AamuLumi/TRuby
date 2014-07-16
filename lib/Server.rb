require 'socket'

module TRuby::Server

	def launchServer
		@nbClients = 0
		@clients = Array.new
		@server = TCPServer.new 32456
		@serverStopped = false
		Thread.new do
			puts "[SERVER] Launch Connection Thread"
			while (@nbClients < 2 && !@serverStoppeds)
				@clients[@nbClients] = @server.accept
				puts "[SERVER] New client"
				@nbClients += 1

				Thread.new do #Create a new Thread for listening client

					numClient = @nbClients - 1
					puts "[SERVER] Thread client #{numClient}"
					client = @clients[numClient]
					while (!@serverStopped)
						puts "[SERVER] Waiting message from client #{numClient}"
						begin
							str = client.gets.chomp
							puts "[SERVER] Receive #{str}"
							serverAnalyzeMessage(str, numClient)
						rescue
							puts "[SERVER] Error with client #{numClient}"
							stopServer
						end
					end
				end
			end
		end
		@isServer = true
		joinServer
	end

	def sendToClient(i, message)
		puts "To : #{i} - #{message}"
		@clients[i].puts message
	end

	def sendToClients(message)
		@clients.each do |c|
			c.puts message
		end
	end

	def sendToClientsExcept(message, n)
		puts "[SERVER] Message #{message} send to all clients except #{n}"
		(0...@nbClients).each do |i|
			@clients[i].puts message if i != n
		end
	end

	def stopServer
		puts "[SERVER] Stop server"
		@serverStopped = true
		@clients.each do |c|
			c.close if c != nil
		end
	end

	def serverAnalyzeMessage(message, numClient)
		puts "[SERVER] Message from #{numClient} : #{message}"
		sendToClientsExcept(message, numClient)
	end

end