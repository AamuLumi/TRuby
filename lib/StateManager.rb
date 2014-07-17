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
				validateParams
				initializeWaiting
				launchServer
			elsif (state == STATE_WAITING_SERVER)
				@actualState = STATE_WAITING_SERVER
				validateParams
				initializeWaiting
				joinServer
			elsif (state == STATE_MENU)
				@actualState = STATE_MENU
				initializeMenu
			elsif (state == STATE_MAP_SELECTION)
				@actualState = STATE_MAP_SELECTION
				initializeMapSelection
			elsif (state == STATE_PARAMS_SELECTION)
				@actualState = STATE_PARAMS_SELECTION
				initializeParamsSelection
			elsif (state == STATE_LAUNCHING_GAME && @actualState == STATE_WAITING_CLIENT)
				sendMapToClients
				(0...@nbPlayers).each do |i|
					sendToClient(i, "init~$numPlayer!#{i}")
				end
				sendToClients("init~$startGame")
				@actualState = STATE_LAUNCHING_GAME
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