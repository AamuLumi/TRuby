
module TRuby::Printers

	def needs_cursor?
		@mouseShown
	end

	def toXWindowDimension(size)
		(size * WIDTH) / (@map.width * @map.tile_size)
	end 

	def toYWindowDimension(size)
		(size * HEIGHT) / (@map.height * @map.tile_size)
	end

	def printWindowMessage(message)
		@image_window.draw((WIDTH - WINDOW_WIDTH)/2, (HEIGHT - WINDOW_HEIGHT)/2, 0)
		@font_window.draw(message, (WIDTH - WINDOW_WIDTH)/2 + 8, (HEIGHT - WINDOW_HEIGHT)/2 + 8, 0)
	end

	### STATE_MENU

	def printBackgroundMenu
		@image_background.draw(0,0,0)
	end

	def printItemsMenu
		@image_create_server.draw(270,150,0)
		@image_join_server.draw(270,225,0)
		@image_quit.draw(270,300,0)
	end

	def printSelection
		if (@selection == SELECTION_CREATE_SERVER)
			@image_selection.draw(265,149,0)
		elsif (@selection == SELECTION_JOIN_SERVER)
			@image_selection.draw(265,224,0)
		elsif (@selection == SELECTION_QUIT)
			@image_selection.draw(265,299,0)
		end
	end

	### STATE_PLAYING

	def printMap
		i, j = 0, 0

		while i < @map.width do 
			while j < @map.height do
				printTileMap(i, j, @map.datasValueFor(i, j))
				j += 1
			end
			i += 1
			j = 0
		end
	end

	def printPlayers
		@players.each do |p|
			@image_player.draw(toXWindowDimension(p.x * @map.tile_size), toYWindowDimension(p.y * @map.tile_size), 0, @dx, @dy) if p != nil
		end
	end

	def printTileMap(x, y, value=0)
		case value
		when 1 
			@image_mur.draw(toXWindowDimension(x*@map.tile_size), toYWindowDimension(y*@map.tile_size), 0, @dx, @dy)
		else 
			@image_void.draw(toXWindowDimension(x*@map.tile_size), toYWindowDimension(y*@map.tile_size), 0, @dx, @dy)
		end
	end

	def printBombs
		@bombs.keys.each do |k|
			@image_bomb.draw(toXWindowDimension(k.split("_")[0].to_i * @map.tile_size), toYWindowDimension(k.split("_")[1].to_i * @map.tile_size), 0, @dx, @dy)
		end
	end

	def printPowerUps
		@powerups.keys.each do |k|
			if (@powerups[k].class == TRuby::Fireup)
				@image_fireup.draw(toXWindowDimension(k.split("_")[0].to_i * @map.tile_size), toYWindowDimension(k.split("_")[1].to_i * @map.tile_size), 0, @dx, @dy)
			elsif (@powerups[k].class == TRuby::Bombup)
				@image_bombup.draw(toXWindowDimension(k.split("_")[0].to_i * @map.tile_size), toYWindowDimension(k.split("_")[1].to_i * @map.tile_size), 0, @dx, @dy)
			elsif (@powerups[k].class == TRuby::Timeup)
				@image_timeup.draw(toXWindowDimension(k.split("_")[0].to_i * @map.tile_size), toYWindowDimension(k.split("_")[1].to_i * @map.tile_size), 0, @dx, @dy)  
			end
		end
	end

	def printExplosions
		@explosions.each do |e|
			e.positions.each do |p|
				@image_explosion.draw(toXWindowDimension(p.split("_")[0].to_i * @map.tile_size), toYWindowDimension(p.split("_")[1].to_i * @map.tile_size), 0, @dx, @dy, 0xffffff + (e.getAlpha << 24))
			end
		end
	end

end