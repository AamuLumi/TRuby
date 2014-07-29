require 'socket'

module TRuby::Server

	def launchServer
		@nbClients = 0
		@clients = Array.new
		if (@server == nil)
			@server = TCPServer.new @port
			@server.setsockopt(Socket::SOL_SOCKET, Socket::SO_REUSEADDR, 1)
		end
		@serverStopped = false
		Thread.new do
			debug "[SERVER] Launch Connection Thread"
			while (@nbClients < @nbPlayers && !@serverStopped)
				@clients[@nbClients] = @server.accept
				debug "[SERVER] New client"
				@nbClients += 1

				Thread.new do #Create a new Thread for listening client

					numClient = @nbClients - 1
					debug "[SERVER] Thread client #{numClient}"
					client = @clients[numClient]
					clientConnected = true
					while (!@serverStopped and clientConnected)
						debug "[SERVER] Waiting message from client #{numClient}"
						begin
							str = client.gets.chomp
							debug "[SERVER] Receive #{str}"
							serverAnalyzeMessage(str, numClient)
						rescue
							debug "[SERVER] Error with client #{numClient}"
							removeClient(client)
							clientConnected = false
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
		aMessage = message.split("~$")
		case aMessage[0]
		when "init"
			aInit = aMessage[1].split("!")
			case aInit[0]
			when "ready"
				@nbClientsReady += 1
			end
		else
			sendToClientsExcept(message, numClient)
		end
	end

	def sendMapToClients()
		sendToClientsExcept("init~$nbPlayers!#{@nbPlayers}~$", 0)
		sendToClientsExcept("init~$mapDatas!#{@map.name}~$", 0)

		f = File.open(@map.path, "r")
		f.each_line do |line|
			sendToClientsExcept("datas~$#{line}", 0)
		end

		sendToClientsExcept("init~$endMapDatas~$", 0)
	end

	def sendDeathPlayer(n)
		sendToClientsExcept("ins~$death!#{n}~$", 0)
	end

	def removeClient(client)
		@clients.delete(client)
		@nbClients -= 1
	end

end