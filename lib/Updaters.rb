
module TRuby::Updaters

	def updateWaitingServer
		@enterPressed = false
	end

	def updateWaitingClient
		@enterPressed = false
		if (@nbClients == @nbPlayers)
			changeState(STATE_LAUNCHING_GAME)
		end
	end

	def updateMenu
		if !@moveDown and (button_down? Gosu::KbDown or button_down? Gosu::GpDown)
			@selection = (@selection + 1) % @menuItems.size
			@moveDown = true
		elsif @moveDown and !(button_down? Gosu::KbDown or button_down? Gosu::GpDown) then
			@moveDown = false
		end

		if !@moveUp and (button_down? Gosu::KbUp or button_down? Gosu::GpUp) then
			@selection = (@selection - 1) % @menuItems.size
			@moveUp = true
		elsif @moveUp and !(button_down? Gosu::KbUp or button_down? Gosu::GpUp) then
			@moveUp = false
		end

		if !@enterPressed and (button_down? Gosu::KbReturn or button_down? Gosu::GpButton1)
			@enterPressed = true
			if (@selection == SELECTION_QUIT)
				close
			elsif (@selection == SELECTION_CREATE_SERVER)
				changeState(STATE_MAP_SELECTION)
			elsif (@selection == SELECTION_JOIN_SERVER)
				changeState(STATE_PARAMS_SELECTION)
			end
		elsif @enterPressed and !(button_down? Gosu::KbReturn or button_down? Gosu::GpButton1) then
			@enterPressed = false
		end
	end

	def updateMapSelection
		if !@moveDown and (button_down? Gosu::KbDown or button_down? Gosu::GpDown)
			@selection = (@selection + 1) % (@maps.size() +1)
			@moveDown = true
		elsif @moveDown and !(button_down? Gosu::KbDown or button_down? Gosu::GpDown) then
			@moveDown = false
		end

		if !@moveUp and (button_down? Gosu::KbUp or button_down? Gosu::GpUp) then
			@selection = (@selection - 1) % (@maps.size() +1)
			@moveUp = true
		elsif @moveUp and !(button_down? Gosu::KbUp or button_down? Gosu::GpUp) then
			@moveUp = false
		end

		if !@enterPressed and (button_down? Gosu::KbReturn or button_down? Gosu::GpButton1) 
			@enterPressed = true
			if (@selection == @maps.size())
				changeState(STATE_MENU)
			else
				@map = @maps[@selection]
				changeState(STATE_PARAMS_SELECTION)
			end
		elsif @enterPressed and !(button_down? Gosu::KbReturn or button_down? Gosu::GpButton1) then
			@enterPressed = false
		end
	end

	def updateParamsSelection
		if (@keyboardIn)
			keyboardNumInput(@paramsItems[@selection])
		else
			if !@moveDown and (button_down? Gosu::KbDown or button_down? Gosu::GpDown)
				@selection = (@selection + 1) % (@paramsItems.size() +1)
				@moveDown = true
			elsif @moveDown and !(button_down? Gosu::KbDown or button_down? Gosu::GpDown) then
				@moveDown = false
			end

			if !@moveUp and (button_down? Gosu::KbUp or button_down? Gosu::GpUp) then
				@selection = (@selection - 1) % (@paramsItems.size() +1)
				@moveUp = true
			elsif @moveUp and !(button_down? Gosu::KbUp or button_down? Gosu::GpUp) then
				@moveUp = false
			end

			if !@moveLeft and (button_down? Gosu::KbLeft or button_down? Gosu::GpLeft) then
				@paramsItems[@selection].decrease if @selection != @paramsItems.size()
				@moveLeft = true
			elsif @moveLeft and !(button_down? Gosu::KbLeft or button_down? Gosu::GpLeft) then
				@moveLeft = false
			end
			if !@moveRight and (button_down? Gosu::KbRight or button_down? Gosu::GpRight) then
				@paramsItems[@selection].increase if @selection != @paramsItems.size()
				@moveRight = true
			elsif @moveRight and !(button_down? Gosu::KbRight or button_down? Gosu::GpRight) then
				@moveRight = false
			end

			if !@enterPressed and (button_down? Gosu::KbReturn or button_down? Gosu::GpButton1) 
				@enterPressed = true
				if (@selection == @paramsItems.size())
					if @isServer
						changeState(STATE_MAP_SELECTION) 
					else
						changeState(STATE_MENU)
					end
				elsif (@selection == SELECTION_PLAY)
					if @isServer
						changeState(STATE_WAITING_CLIENT) 
					else
						changeState(STATE_WAITING_SERVER)
					end
				elsif (!@isServer)
					if (@selection == CLIENT_SELECTION_IP)
						@keyboardIn = true
						@paramsItems[@selection].changeValue(@paramsItems[@selection].value + "_")
					end
				end
			elsif @enterPressed and !(button_down? Gosu::KbReturn or button_down? Gosu::GpButton1) then
				@enterPressed = false
			end
		end
	end

	def updatePlaying
		if !@moveLeft and (button_down? Gosu::KbLeft or button_down? Gosu::GpLeft) then
			if @map.datasValueFor(@player.x() -1, @player.y) & 0x1 != 1 and !bombOn(@player.x() -1, @player.y) and @player.canMove(LEFT)
				@player.move(LEFT) 
				sendMove(LEFT)
			end
			@moveLeft = true
		elsif @moveLeft and !(button_down? Gosu::KbLeft or button_down? Gosu::GpLeft) then
			@moveLeft = false
		end
		if !@moveRight and (button_down? Gosu::KbRight or button_down? Gosu::GpRight) then
			if @map.datasValueFor(@player.x() +1, @player.y) & 0x1 != 1 and !bombOn(@player.x() +1, @player.y) and @player.canMove(RIGHT)
				@player.move(RIGHT) 
				sendMove(RIGHT)
			end
			@moveRight = true
		elsif @moveRight and !(button_down? Gosu::KbRight or button_down? Gosu::GpRight) then
			@moveRight = false
		end
		if !@moveUp and (button_down? Gosu::KbUp or button_down? Gosu::GpUp) then
			if @map.datasValueFor(@player.x , (@player.y() -1)) & 0x1 != 1 and !bombOn(@player.x(), @player.y() -1) and @player.canMove(UP)
				@player.move(UP) 
				sendMove(UP)
			end
			@moveUp = true
		elsif @moveUp and !(button_down? Gosu::KbUp or button_down? Gosu::GpUp) then
			@moveUp = false
		end
		if !@moveDown and (button_down? Gosu::KbDown or button_down? Gosu::GpDown) then
			if @map.datasValueFor(@player.x , (@player.y() +1)) & 0x1 != 1 and !bombOn(@player.x(), @player.y() +1) and @player.canMove(DOWN)
				@player.move(DOWN) 
				sendMove(DOWN)
			end
			@moveDown = true
		elsif @moveDown and !(button_down? Gosu::KbDown or button_down? Gosu::GpDown) then
			@moveDown = false
		end
		if !@bombPut and !bombOn(@player.x, @player.y) and @player.hasBomb and (button_down? Gosu::KbSpace or button_down? Gosu::GpButton1) then
			putBomb(@num_actual_player, @players[@num_actual_player].x, @players[@num_actual_player].y)
			sendBomb(@players[@num_actual_player].x, @players[@num_actual_player].y)
			@bombPut = true
		elsif @bombPut and !(button_down? Gosu::KbSpace or button_down? Gosu::GpButton1)
			@bombPut = false
		end

		checkBombs
		checkPlayers
		checkExplosions
	end

	def keyboardNumInput(param)
		if !@keyNum1 and (button_down? Gosu::KbNumpad1 or button_down? Gosu::Kb1)
			@keyNum1 = true
			param.removeLastCharToValue
			param.addToValue("1_")
		elsif @keyNum1 and !(button_down? Gosu::KbNumpad1 or button_down? Gosu::Kb1)
			@keyNum1 = false
		end

		if !@keyNum2 and (button_down? Gosu::KbNumpad2 or button_down? Gosu::Kb2)
			@keyNum2 = true
			param.removeLastCharToValue
			param.addToValue("2_")
		elsif @keyNum2 and !(button_down? Gosu::KbNumpad2 or button_down? Gosu::Kb2)
			@keyNum2 = false
		end

		if !@keyNum3 and (button_down? Gosu::KbNumpad3 or button_down? Gosu::Kb3)
			@keyNum3 = true
			param.removeLastCharToValue
			param.addToValue("3_")
		elsif @keyNum3 and !(button_down? Gosu::KbNumpad3 or button_down? Gosu::Kb3)
			@keyNum3 = false
		end

		if !@keyNum4 and (button_down? Gosu::KbNumpad4 or button_down? Gosu::Kb4)
			@keyNum4 = true
			param.removeLastCharToValue
			param.addToValue("4_")
		elsif @keyNum4 and !(button_down? Gosu::KbNumpad4 or button_down? Gosu::Kb4)
			@keyNum4 = false
		end

		if !@keyNum5 and (button_down? Gosu::KbNumpad5 or button_down? Gosu::Kb5)
			@keyNum5 = true
			param.removeLastCharToValue
			param.addToValue("5_")
		elsif @keyNum5 and !(button_down? Gosu::KbNumpad5 or button_down? Gosu::Kb5)
			@keyNum5 = false
		end

		if !@keyNum6 and (button_down? Gosu::KbNumpad6 or button_down? Gosu::Kb6)
			@keyNum6 = true
			param.removeLastCharToValue
			param.addToValue("6_")
		elsif @keyNum6 and !(button_down? Gosu::KbNumpad6 or button_down? Gosu::Kb6)
			@keyNum6 = false
		end

		if !@keyNum7 and (button_down? Gosu::KbNumpad7 or button_down? Gosu::Kb7)
			@keyNum7 = true
			param.removeLastCharToValue
			param.addToValue("7_")
		elsif @keyNum7 and !(button_down? Gosu::KbNumpad7 or button_down? Gosu::Kb7)
			@keyNum7 = false
		end

		if !@keyNum8 and (button_down? Gosu::KbNumpad8 or button_down? Gosu::Kb8)
			@keyNum8 = true
			param.removeLastCharToValue
			param.addToValue("8_")
		elsif @keyNum8 and !(button_down? Gosu::KbNumpad8 or button_down? Gosu::Kb8)
			@keyNum8 = false
		end

		if !@keyNum9 and (button_down? Gosu::KbNumpad9 or button_down? Gosu::Kb9)
			@keyNum9 = true
			param.removeLastCharToValue
			param.addToValue("9_")
		elsif @keyNum9 and !(button_down? Gosu::KbNumpad9 or button_down? Gosu::Kb9)
			@keyNum9 = false
		end

		if !@keyNum0 and (button_down? Gosu::KbNumpad0 or button_down? Gosu::Kb0)
			@keyNum0 = true
			param.removeLastCharToValue
			param.addToValue("0_")
		elsif @keyNum0 and !(button_down? Gosu::KbNumpad0 or button_down? Gosu::Kb0)
			@keyNum0 = false
		end

		if !@keyDot and (button_down? Gosu::KbPeriod or button_down? Gosu::KbComma)
			@keyDot = true
			param.removeLastCharToValue
			param.addToValue("._")
		elsif @keyDot and !(button_down? Gosu::KbPeriod or button_down? Gosu::KbComma)
			@keyDot = false
		end

		if !@keyDelete and (button_down? Gosu::KbDelete or button_down? Gosu::KbBackspace)
			@keyDelete = true
			param.removeLastCharToValue
			param.removeLastCharToValue
			param.addToValue("_")
		elsif @keyDelete and !(button_down? Gosu::KbDelete or button_down? Gosu::KbBackspace)
			@keyDelete = false
		end

		if !@enterPressed and (button_down? Gosu::KbReturn or button_down? Gosu::GpButton1) 
			@enterPressed = true
			@keyboardIn = false
			param.removeLastCharToValue
		elsif @enterPressed and !(button_down? Gosu::KbReturn or button_down? Gosu::GpButton1) then
			@enterPressed = false
		end
	end
end