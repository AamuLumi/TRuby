

module TRuby::GameMethods

	def listMaps
		@maps = Array.new
		Dir["./maps/*.map"].each do |m|
			@maps.push(MapReader::Map.new(getMapNameFromPath(m), m))
		end
	end

	def validateParams
		if (@isServer)
			@nbPlayers = @paramsItems[SELECTION_NB_PLAYERS].value
			@port = @paramsItems[SELECTION_PORT].value
		else
			@ip = @paramsItems[CLIENT_SELECTION_IP].value
			@port = @paramsItems[CLIENT_SELECTION_PORT].value
		end
	end

	def getMapNameFromPath(p)
		p.split("/").pop.split(".")[0].capitalize
	end

	def bombOn(x, y)
		@bombs["#{x}_#{y}"] != nil
	end

	def putBomb(n, x, y)
		@bombs["#{x}_#{y}"] = TRuby::Bomb.new(@players[n], Time.now)
		@players[n].putBomb
	end

	def powerUpOn(x, y)
		@powerups.keys.any? {|key| key == "#{x}_#{y}"}
	end

	def removePowerUpOn(x, y)
		@powerups.delete("#{x}_#{y}")
	end

	def popPowerUp(x, y)
		if (@isServer)
			r = rand(100)

			if (r >= 1 && r <= 10)
				addFireup(x, y, 1)
				sendPowerUp(FIREUP, x, y, 1)
			elsif (r >= 11 && r <= 20)
				addBombup(x, y, 1)
				sendPowerUp(BOMBUP, x, y, 1)
			elsif (r >= 21 && r <= 25)
				addTimeup(x, y, 250)
				sendPowerUp(TIMEUP, x, y, 250)
			elsif (r >= 26 && r <= 30)
				addTimeup(x, y, -250)
				sendPowerUp(TIMEUP, x, y, -250)
			end
		end
	end

	def addFireup(x, y, n)
		@powerups["#{x}_#{y}"] = TRuby::Fireup.new(x, y, n)
	end

	def addBombup(x, y, n)
		@powerups["#{x}_#{y}"] = TRuby::Bombup.new(x, y, n)
	end

	def addTimeup(x, y, n)
		@powerups["#{x}_#{y}"] = TRuby::Timeup.new(x, y, n)
	end


	def bombExplosion(bomb, wallExploded=nil)
		bomb.explode 

		wallExploded = Array.new if wallExploded == nil

		positions = Array.new
		positions.push("#{bomb.x}_#{bomb.y}")

		bombExplosionOnLeft(bomb, positions, wallExploded)
		bombExplosionOnRight(bomb, positions, wallExploded)	
		bombExplosionOnUp(bomb, positions, wallExploded)
		bombExplosionOnDown(bomb, positions, wallExploded)

		@explosions.push(TRuby::Explosion.new(positions, Time.now, DEFAULT_EXPLOSION_DURATION))
		@bombs.delete("#{bomb.x}_#{bomb.y}")
	end

	def bombExplosionOnLeft(bomb, positions, wallExploded)
		wallFound = false
		(1...bomb.power+1).each do |i|
			if (!wallFound)
				positions.push("#{bomb.x-i}_#{bomb.y}")
				if wallDestructByPreviousBomb?(bomb.x-i, bomb.y, wallExploded)
					puts "#{bomb.x-i}_#{bomb.y}"
					wallFound = true
				elsif (@map.datasValueFor(bomb.x-i, bomb.y) == 1 and (bomb.x() -i) >= 0)
					@map.changeData(bomb.x-i, bomb.y, 0)
					popPowerUp(bomb.x-i, bomb.y)
					wallFound = true
					wallExploded.push("#{bomb.x-i}_#{bomb.y}")
				elsif powerUpOn(bomb.x-i, bomb.y) and (bomb.x() -i) >= 0
					removePowerUpOn(bomb.x-i, bomb.y)
				end
				if (bombOn(bomb.x-i, bomb.y)) and (bomb.x() -i) >= 0
					bombExplosion(@bombs["#{bomb.x-i}_#{bomb.y}"], wallExploded) if (!@bombs["#{bomb.x-i}_#{bomb.y}"].exploded)
				end
			end
		end
	end

	def bombExplosionOnRight(bomb, positions, wallExploded)
		wallFound = false
		(1...bomb.power+1).each do |i|
			if (!wallFound)
				positions.push("#{bomb.x+i}_#{bomb.y}")
				if wallDestructByPreviousBomb?(bomb.x+i, bomb.y, wallExploded)
					puts "#{bomb.x-i}_#{bomb.y}"
					wallFound = true
				elsif (@map.datasValueFor(bomb.x+i, bomb.y) == 1 and (bomb.x()+i) < @map.width) 
					@map.changeData(bomb.x+i, bomb.y, 0)
					popPowerUp(bomb.x+i, bomb.y)
					wallFound = true
					wallExploded.push("#{bomb.x+i}_#{bomb.y}")
				elsif powerUpOn(bomb.x+i, bomb.y) and (bomb.x()+i) < @map.width
					removePowerUpOn(bomb.x+i, bomb.y)
				end
				if bombOn(bomb.x+i, bomb.y) and (bomb.x()+i) < @map.width
					bombExplosion(@bombs["#{bomb.x+i}_#{bomb.y}"], wallExploded) if (!@bombs["#{bomb.x+i}_#{bomb.y}"].exploded)
				end
			end
		end
	end

	def bombExplosionOnUp(bomb, positions, wallExploded)
		wallFound = false
		(1...bomb.power+1).each do |i|
			if (!wallFound)
				positions.push("#{bomb.x}_#{bomb.y-i}")
				if wallDestructByPreviousBomb?(bomb.x, bomb.y-i, wallExploded)
					wallFound = true
				elsif (@map.datasValueFor(bomb.x, bomb.y-i) == 1 and (bomb.y() -i) >= 0)
					@map.changeData(bomb.x, bomb.y-i, 0)
					popPowerUp(bomb.x, bomb.y-i)
					wallFound = true
					wallExploded.push("#{bomb.x}_#{bomb.y-i}")
				elsif powerUpOn(bomb.x, bomb.y-i) and (bomb.y() -i) >= 0
					removePowerUpOn(bomb.x, bomb.y-i)
				end
				if (bombOn(bomb.x, bomb.y-i)) and (bomb.y() -i) >= 0
					bombExplosion(@bombs["#{bomb.x}_#{bomb.y-i}"], wallExploded) if (!@bombs["#{bomb.x}_#{bomb.y-i}"].exploded)
				end
			end
		end
	end

	def bombExplosionOnDown(bomb, positions, wallExploded)
		wallFound = false
		(1...bomb.power+1).each do |i|
			if (!wallFound)
				positions.push("#{bomb.x}_#{bomb.y+i}")
				if wallDestructByPreviousBomb?(bomb.x, bomb.y+i, wallExploded)
					wallFound = true
				elsif (@map.datasValueFor(bomb.x, bomb.y+i) == 1 and (bomb.y() + i) < @map.height)
					@map.changeData(bomb.x, bomb.y+i, 0)
					popPowerUp(bomb.x, bomb.y+i)
					wallFound = true
					wallExploded.push("#{bomb.x}_#{bomb.y+i}")
				elsif powerUpOn(bomb.x, bomb.y+i) and (bomb.y() + i) < @map.height
					removePowerUpOn(bomb.x, bomb.y+i)
				end
				if (bombOn(bomb.x, bomb.y+i)) and (bomb.y() + i) < @map.height
					bombExplosion(@bombs["#{bomb.x}_#{bomb.y+i}"], wallExploded) if (!@bombs["#{bomb.x}_#{bomb.y+i}"].exploded)
				end
			end
		end
	end

	def wallDestructByPreviousBomb?(x, y, positions)
		return false if positions == nil
		positions.each do |p|
			if p.split("_")[0].to_i == x and p.split("_")[1].to_i == y
				return true
			end
		end

		return false
	end


	def movePlayer(num, direction)
		@players[num].move(direction)
	end

	def waitInitialisationPlaying
		while (@initializePlaying)
			#puts "[CLIENT]Waiting Initialisation"
		end
	end

	def newPlayer(numPlayer, x, y)
		@players[numPlayer] = TRuby::Player.new(x, y, @map.width, @map.height)
	end


end