require 'socket'

module TRuby::Client

	def joinServer
		@client = TCPSocket.new('localhost', 32456)
		@client_messages = Array.new
		@connection_closed = false
		Thread.new do 
			while (!@connection_closed)
				puts "[CLIENT] Waiting message"
				str = @client.gets.chomp
				clientAnalyzeMessage(str)
			end
			puts "[CLIENT] Receving end"
		end 
	end

	def clientAnalyzeMessage(message)
		puts "[CLIENT] Analyze of #{message}"
		aMessage = message.split("~$")
		case aMessage[0]
		when "ins"
			analyzeInstruction(aMessage[1])
		when "init"
			analyzeInit(aMessage[1])
		else
			@client_messages.push(aMessage[1])
		end
	end

	def analyzeInit(init)
		puts "[CLIENT] Determined as Initialization : #{init}"
		aInit = init.split("!")
		case aInit[0]
		when "numPlayer" # Pour définir le numéro du client
			@num_actual_player = aInit[1].to_i
		when "startGame" # Pour démarrer le jeu
			needChangeToState(STATE_PLAYING)
		end
	end

	def analyzeInstruction(ins)
		waitInitialisationPlaying
		puts "[CLIENT] Determined as Instruction : #{ins}"
		aIns = ins.split("!")
		case aIns[0]
		when "newPlayer" # Pour ajouter un joueur newPlayer!numPlayer!x!y
			puts "[CLIENT] Add new player instruction"
			@mutexPlayerDatas.synchronize do
				newPlayer(aIns[1].to_i, aIns[2].to_i, aIns[3].to_i)
				puts "[CLIENT] New player added"
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
		end
	end

	def newMessage?
		!@client_messages.empty?
	end

	def leaveServer
		puts "[CLIENT] Leaving Server"
		@connection_closed = true
		@client.close if @client != nil
	end

	def sendMessage(message)
		puts "[CLIENT] Sending message #{message}"
		@client.puts message
	end

	# Send message methods
	def sendPlayerInit(numPlayer, x, y)
		sendMessage("ins~$newPlayer!#{numPlayer}!#{x}!#{y}")
	end

	def sendMove(move)
		sendMessage("ins~$move!#{@num_actual_player}!#{move}")
	end

	def sendBomb(x, y)
		sendMessage("ins~$bomb!#{@num_actual_player}!#{x}!#{y}")
	end

	def sendPowerUp(type, x, y, power)
		sendMessage("ins~$pwup!#{type}!#{x}!#{y}!#{power}")
	end
end

