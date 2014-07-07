
module TRuby::StateManager

		def changeState(state)
			if (state == STATE_PLAYING)
				@actualState = STATE_PLAYING
				flush
				initializePlaying
			end
		end

end