
module TRuby::Updaters

	def updateMenu
		if !@moveDown and (button_down? Gosu::KbDown or button_down? Gosu::GpDown)
			@selection = (@selection + 1) %2
			@moveDown = true
		elsif @moveDown and !(button_down? Gosu::KbDown or button_down? Gosu::GpDown) then
			@moveDown = false
		end

		if !@moveUp and (button_down? Gosu::KbUp or button_down? Gosu::GpUp) then
			@selection = (@selection - 1) %2
			@moveUp = true
		elsif @moveUp and !(button_down? Gosu::KbUp or button_down? Gosu::GpUp) then
			@moveUp = false
		end

		if (button_down? Gosu::KbReturn or button_down? Gosu::GpButton1)
			if (@selection == SELECTION_QUIT)
				close
			elsif (@selection == SELECTION_PLAY)
				changeState(STATE_PLAYING)
			end
		end
	end

	def updatePlaying
		if !@moveLeft and (button_down? Gosu::KbLeft or button_down? Gosu::GpLeft) then
			@player.move(TRuby::LEFT) if @map.datasValueFor(@player.x() -1, @player.y) & 0x1 != 1 and !bombOn(@player.x() -1, @player.y)
			@moveLeft = true
		elsif @moveLeft and !(button_down? Gosu::KbLeft or button_down? Gosu::GpLeft) then
			@moveLeft = false
		end
		if !@moveRight and (button_down? Gosu::KbRight or button_down? Gosu::GpRight) then
			@player.move(TRuby::RIGHT) if @map.datasValueFor(@player.x() +1, @player.y) & 0x1 != 1 and !bombOn(@player.x() +1, @player.y)
			@moveRight = true
		elsif @moveRight and !(button_down? Gosu::KbRight or button_down? Gosu::GpRight) then
			@moveRight = false
		end
		if !@moveUp and (button_down? Gosu::KbUp or button_down? Gosu::GpUp) then
			@player.move(TRuby::UP) if @map.datasValueFor(@player.x , (@player.y() -1)) & 0x1 != 1 and !bombOn(@player.x(), @player.y() -1)
			@moveUp = true
		elsif @moveUp and !(button_down? Gosu::KbUp or button_down? Gosu::GpUp) then
			@moveUp = false
		end
		if !@moveDown and (button_down? Gosu::KbDown or button_down? Gosu::GpDown) then
			@player.move(TRuby::DOWN) if @map.datasValueFor(@player.x , (@player.y() +1)) & 0x1 != 1 and !bombOn(@player.x(), @player.y() +1)
			@moveDown = true
		elsif @moveDown and !(button_down? Gosu::KbDown or button_down? Gosu::GpDown) then
			@moveDown = false
		end
		if !@bombPut and !bombOn(@player.x, @player.y) and @player.hasBomb and (button_down? Gosu::KbSpace or button_down? Gosu::GpButton1) then
			@bombs["#{@player.x}_#{@player.y}"] = TRuby::Bomb.new(@player, Time.now)
			@player.putBomb
			@bombPut = true
		elsif @bombPut and !(button_down? Gosu::KbSpace or button_down? Gosu::GpButton1)
			@bombPut = false
		end

		checkBombs
		checkPlayers
	end

end