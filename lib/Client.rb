require 'socket'

module TRuby::Client

	def joinServer
		@client = TCPSocket.new('localhost', @port)
		@client_messages = Array.new
		@connection_closed = false

		debug "[CLIENT] Beginning connection"
		Thread.new do 
			sendReady
			while (!@connection_closed)
				begin
					debug "[CLIENT] Waiting message"
					str = @client.gets.chomp
					clientAnalyzeMessage(str)
				rescue
					debug "[CLIENT] Error with server"
					@connection_closed = true
				end
			end
			debug "[CLIENT] Receiving finished"
		end 
	end

	def clientAnalyzeMessage(message)
		debug "[CLIENT] Analyze of #{message}"
		aMessage = message.split("~$")
		case aMessage[0]
		when "datas"
			begin
				@openedFile.puts aMessage[1]
			rescue
				debug "[ERROR] Writing map file"
			end
		when "ins"
			analyzeInstruction(aMessage[1])
		when "init"
			analyzeInit(aMessage[1])
		else
			@client_messages.push(aMessage[1])
		end

		if aMessage.size > 2 # Cas ou 2 trames se suivent
			clientAnalyzeMessage(aMessage[2...aMessage.size].join("~$"))
		end
	end

	def analyzeInit(init)
		debug "[CLIENT] Determined as Initialization : #{init}"
		aInit = init.split("!")
		case aInit[0]
		when "numPlayer" # Pour définir le numéro du client
			@num_actual_player = aInit[1].to_i
		when "nbPlayers"
			@nbPlayers = aInit[1].to_i
		when "changeToGame" # Pour démarrer le jeu
			needChangeToState(STATE_PLAYING)
		when "startGame"
			@roundLaunched = true
		when "mapDatas"
			@mapName = aInit[1]
			@openedFile = File.open("./maps/#{aInit[1]}.map", 'w')
		when "endMapDatas"
			@openedFile.close
			@map = MapReader::Map.new(@mapName, "./maps/#{@mapName}.map")
		end
	end

	def analyzeInstruction(ins)
		waitInitialisationPlaying
		debug "[CLIENT] Determined as Instruction : #{ins}"
		aIns = ins.split("!")
		case aIns[0]
		when "newPlayer" # Pour ajouter un joueur newPlayer!name!numPlayer!x!y
			debug "[CLIENT] Add new player instruction"
			@mutexPlayerDatas.synchronize do
				if existPlayerWithName?(aIns[1])
					debug "[CLIENT] Player found !"
					puts "#{idForPlayerName(aIns[1])} #{aIns[2].to_i}"
					@players[idForPlayerName(aIns[1])], @players[aIns[2].to_i] = @players[aIns[2].to_i], @players[idForPlayerName(aIns[1])]
					@players[aIns[2].to_i].setCoordonates(aIns[3].to_i, aIns[4].to_i)
					@players[aIns[2].to_i].live
				else
					debug "[CLIENT] New player added"
					newPlayer(aIns[1], aIns[2].to_i, aIns[3].to_i, aIns[4].to_i)
				end
			end
		when "move" # move!numPlayer!numDirection
			movePlayer(aIns[1].to_i, aIns[2].to_i)
		when "bomb" # bomb!numPlayer!x!y
			putBomb(aIns[1].to_i, aIns[2].to_i, aIns[3].to_i)
		when "pwup" # pwup!typePowerUp!x!y!n
			case aIns[1].to_i
			when FIREUP
				addFireup(aIns[2].to_i, aIns[3].to_i, aIns[4].to_i)
			when BOMBUP
				addBombup(aIns[2].to_i, aIns[3].to_i, aIns[4].to_i)
			when TIMEUP
				addTimeup(aIns[2].to_i, aIns[3].to_i, aIns[4].to_i)
			end
		when "death"
			@players[aIns[1].to_i].die
			@nbPlayersAlive -= 1
			puts @nbPlayersAlive
		end
	end

	def newMessage?
		!@client_messages.empty?
	end

	def leaveServer
		debug "[CLIENT] Leaving Server"
		@client.close if @client != nil and !@connection_closed
		@connection_closed = true
	end

	def sendMessage(message)
		debug "[CLIENT] Sending message #{message}"
		@client.puts message
	end

	# Send message methods
	def sendPlayerInit(name, numPlayer, x, y)
		sendMessage("ins~$newPlayer!#{name}!#{numPlayer}!#{x}!#{y}~$")
	end

	def sendMove(move)
		sendMessage("ins~$move!#{@num_actual_player}!#{move}~$")
	end

	def sendBomb(x, y)
		sendMessage("ins~$bomb!#{@num_actual_player}!#{x}!#{y}~$")
	end

	def sendPowerUp(type, x, y, power)
		sendMessage("ins~$pwup!#{type}!#{x}!#{y}!#{power}~$")
	end

	def sendReady
		sendMessage("init~$ready!#{@num_actual_player}~$")
	end
end

