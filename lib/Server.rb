require 'socket'

module TRuby::Server

	def launchServer
		@nbClients = 0
		@clients = Array.new
		@server = TCPServer.new @port
		@serverStopped = false
		Thread.new do
			debug "[SERVER] Launch Connection Thread"
			while (@nbClients < 2 && !@serverStoppeds)
				@clients[@nbClients] = @server.accept
				debug "[SERVER] New client"
				@nbClients += 1

				Thread.new do #Create a new Thread for listening client

					numClient = @nbClients - 1
					debug "[SERVER] Thread client #{numClient}"
					client = @clients[numClient]
					while (!@serverStopped)
						debug "[SERVER] Waiting message from client #{numClient}"
						begin
							str = client.gets.chomp
							debug "[SERVER] Receive #{str}"
							serverAnalyzeMessage(str, numClient)
						rescue
							debug "[SERVER] Error with client #{numClient}"
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
		debug "To : #{i} - #{message}"
		@clients[i].puts message
	end

	def sendToClients(message)
		@clients.each do |c|
			c.puts message
		end
	end

	def sendToClientsExcept(message, n)
		debug "[SERVER] Message #{message} send to all clients except #{n}"
		(0...@nbClients).each do |i|
			@clients[i].puts message if i != n
		end
	end

	def stopServer
		debug "[SERVER] Stop server"
		@serverStopped = true
		@clients.each do |c|
			c.close if c != nil
		end
	end

	def serverAnalyzeMessage(message, numClient)
		debug "[SERVER] Message from #{numClient} : #{message}"
		sendToClientsExcept(message, numClient)
	end

	def sendMapToClients()
		sendToClientsExcept("init~$mapDatas!#{@map.name}", 0)

		f = File.open(@map.path, "r")
		f.each_line do |line|
			sendToClientsExcept("datas~$#{line}", 0)
		end

		sendToClientsExcept("init~$endMapDatas", 0)
	end
end