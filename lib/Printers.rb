
module TRuby::Printers

	def needs_cursor?
		@mouseShown
	end

	def toXWindowDimension(size)
		return (size * WIDTH) / 640 if @actualState != STATE_PLAYING
		(size * WIDTH) / (@map.width * @map.tile_size)
	end 

	def toYWindowDimension(size)
		return (size * (HEIGHT - HEIGHT_HUD) )/ 640 if @actualState != STATE_PLAYING
		(size * (HEIGHT - HEIGHT_HUD)) / (@map.height * @map.tile_size)
	end

	def printWindowMessage(message)
		@image_window.draw((WIDTH - WINDOW_WIDTH)/2, (HEIGHT - WINDOW_HEIGHT)/2, 0)
		@font_window.draw(message, (WIDTH - WINDOW_WIDTH)/2 + 8, (HEIGHT - WINDOW_HEIGHT)/2 + 8, 0)
	end

	### STATE_MENU

	def printBackgroundMenu
		@image_background.draw(0,0,0, @dx, @dy)
	end

	def printItemsMenu
		if (@menuItems != nil)
			(0...@menuItems.size).each do |i|
				if @selection == i
					@font_window_big.draw(@menuItems[i], toXWindowDimension(40), toYWindowDimension(150 + i*75), 0, @dx, @dy, 0xff000000)
				else
					@font_window.draw(@menuItems[i], toXWindowDimension(40), toYWindowDimension(150 + i*75), 0, @dx, @dy, 0xff000000)
				end
			end
		end
	end

	### STATE_MAP_SELECTION

	def printMapSelectionTitle
		@font_window_title.draw("Maps available", toXWindowDimension(50), toYWindowDimension(40), 0, @dx, @dy)
	end

	def printMapsList
		if (@maps != nil)
			(0...@maps.size() +1).each do |i|
				if @selection == i
					if i == @maps.size()
						@font_window_big.draw("Return", toXWindowDimension(40), toYWindowDimension(120 + i*30), 0, @dx, @dy, 0xff000000)
					else
						@font_window_big.draw(@maps[i].name, toXWindowDimension(40), toYWindowDimension(120 + i*30), 0, @dx, @dy, 0xff000000)
					end
				else
					if i == @maps.size()
						@font_window.draw("Return", toXWindowDimension(40), toYWindowDimension(120 + i*30), 0, @dx, @dy, 0xff000000)
					else
						@font_window.draw(@maps[i].name, toXWindowDimension(40), toYWindowDimension(120 + i*30), 0, @dx, @dy, 0xff000000)
					end
				end
			end
		end
	end

	def printBackgroundMapSelection
		@image_background_map_selection.draw(0,0,0, @dx, @dy)
	end

	### STATE_PARAMS_SELECTION

	def printParamsSelectionTitle
		@font_window_title.draw("Parameters", toXWindowDimension(50), toYWindowDimension(40), 0, @dx, @dy)
	end

	def printParamsItems
		if (@paramsItems != nil)
			(0...@paramsItems.size() +1).each do |i|
				if @selection == i
					if i == @paramsItems.size()
						@font_window_big.draw("Return", toXWindowDimension(40), toYWindowDimension(120 + i*30), 0, @dx, @dy, 0xff000000)
					else
						if (@paramsItems[i].value != nil)
							@font_window_big.draw(@paramsItems[i].value, toXWindowDimension(360), toYWindowDimension(120 + i*30), 0, @dx, @dy, 0xff000000)
						end
						@font_window_big.draw(@paramsItems[i].name, toXWindowDimension(40), toYWindowDimension(120 + i*30), 0, @dx, @dy, 0xff000000)
					end
				else
					if i == @paramsItems.size()
						@font_window.draw("Return", toXWindowDimension(40), toYWindowDimension(120 + i*30), 0, @dx, @dy, 0xff000000)
					else
						if (@paramsItems[i].value != nil)
							@font_window.draw(@paramsItems[i].value, toXWindowDimension(360), toYWindowDimension(120 + i*30), 0, @dx, @dy, 0xff000000)
						end
						@font_window.draw(@paramsItems[i].name, toXWindowDimension(40), toYWindowDimension(120 + i*30), 0, @dx, @dy, 0xff000000)
					end
				end
			end
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
			if p != nil
				@image_player.draw(toXWindowDimension(p.x * @map.tile_size), toYWindowDimension(p.y * @map.tile_size), 0, @dx, @dy) if !p.dead
			end
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

	def printHUD
		@image_hud.draw(0, (HEIGHT - HEIGHT_HUD), 0, 1,1)

		@image_fireup.draw(HUD_FIREUP_IMAGE, HEIGHT - HEIGHT_HUD + HUD_MARGIN, 0, 1, 1)
		@font_window.draw("x#{@player.power}", HUD_FIREUP_TEXT, HEIGHT - HEIGHT_HUD + HUD_MARGIN, 0, 1, 1, 0xff000000)

		@image_bombup.draw(HUD_BOMBUP_IMAGE, HEIGHT - HEIGHT_HUD + HUD_MARGIN, 0, 1, 1)
		@font_window.draw("x#{@player.bombsRemaining}/#{@player.maxBombs}", HUD_BOMBUP_TEXT, HEIGHT - HEIGHT_HUD + HUD_MARGIN, 0, 1, 1, 0xff000000)

		@image_timeup.draw(HUD_TIMEUP_IMAGE, HEIGHT - HEIGHT_HUD + HUD_MARGIN, 0, 1, 1)
		@font_window.draw("x#{@player.bombDuration/1000}.#{@player.bombDuration%1000}s", HUD_TIMEUP_TEXT, HEIGHT - HEIGHT_HUD + HUD_MARGIN, 0, 1, 1, 0xff000000)
	end

	### STATE_ENDROUND

	def printEndRoundTitle
		if @roundWon
			@font_window_title.draw("Victory !", toXWindowDimension(50), toYWindowDimension(40), 0, @dx, @dy) 
		else
			@font_window_title.draw("Defeat", toXWindowDimension(50), toYWindowDimension(40), 0, @dx, @dy) 
		end
	end

	def printEndRoundItems
		if (@endRoundItems != nil)
			(0...@endRoundItems.size() +1).each do |i|
				if @selection == i
					if i == @endRoundItems.size()
						@font_window_big.draw("Fin de la partie", toXWindowDimension(40), toYWindowDimension(120 + i*30), 0, @dx, @dy, 0xff000000)
					else
						if (@endRoundItems[i].value != nil)
							@font_window_big.draw(@endRoundItems[i].value, toXWindowDimension(360), toYWindowDimension(120 + i*30), 0, @dx, @dy, 0xff000000)
						end
						@font_window_big.draw(@endRoundItems[i].name, toXWindowDimension(40), toYWindowDimension(120 + i*30), 0, @dx, @dy, 0xff000000)
					end
				else
					if i == @endRoundItems.size()
						@font_window.draw("Fin de la partie", toXWindowDimension(40), toYWindowDimension(120 + i*30), 0, @dx, @dy, 0xff000000)
					else
						if (@endRoundItems[i].value != nil)
							@font_window.draw(@endRoundItems[i].value, toXWindowDimension(360), toYWindowDimension(120 + i*30), 0, @dx, @dy, 0xff000000)
						end
						@font_window.draw(@endRoundItems[i].name, toXWindowDimension(40), toYWindowDimension(120 + i*30), 0, @dx, @dy, 0xff000000)
					end
				end
			end
		end
	end
end