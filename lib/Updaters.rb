
module TRuby::Updaters

	def updateWaitingServer

	end

	def updateWaitingClient
		if (@nbClients == @nbPlayers)
			puts "Changement vers lancement"
			changeState(STATE_LAUNCHING_GAME)
		end
	end

	def updateMenu
		if !@moveDown and (button_down? Gosu::KbDown or button_down? Gosu::GpDown)
			@selection = (@selection + 1) %3
			@moveDown = true
		elsif @moveDown and !(button_down? Gosu::KbDown or button_down? Gosu::GpDown) then
			@moveDown = false
		end

		if !@moveUp and (button_down? Gosu::KbUp or button_down? Gosu::GpUp) then
			@selection = (@selection - 1) %3
			@moveUp = true
		elsif @moveUp and !(button_down? Gosu::KbUp or button_down? Gosu::GpUp) then
			@moveUp = false
		end

		if (button_down? Gosu::KbReturn or button_down? Gosu::GpButton1)
			if (@selection == SELECTION_QUIT)
				close
			elsif (@selection == SELECTION_CREATE_SERVER)
				changeState(STATE_WAITING_CLIENT)
			elsif (@selection == SELECTION_JOIN_SERVER)
				changeState(STATE_WAITING_SERVER)
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

end