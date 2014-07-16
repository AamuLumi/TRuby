require "thread"

module TRuby::StateManager

	def needChangeToState(state)
		@next_state = state
		@stateMustBeChanged = true
	end

	def changeState(state)
		@mut.synchronize do
			if (state == STATE_PLAYING)
				@actualState = STATE_PLAYING
				initializePlaying
			elsif (state == STATE_WAITING_CLIENT)
				@actualState = STATE_WAITING_CLIENT
				puts "Demarrage du server"
				launchServer
			elsif (state == STATE_WAITING_SERVER)
				@actualState = STATE_WAITING_SERVER
				joinServer
			elsif (state == STATE_LAUNCHING_GAME && @actualState == STATE_WAITING_CLIENT)
				@actualState = STATE_LAUNCHING_GAME
				(0...@nbPlayers).each do |i|
					sendToClient(i, "init~$numPlayer!#{i}")
				end
				sendToClients("init~$startGame")
			end
		end
	end

	def getActualState()
		@mut.synchronize do
			@actualState
		end
	end

	def checkState()
		if @stateMustBeChanged
			changeState(@next_state)
			@stateMustBeChanged = false
		end
	end


end