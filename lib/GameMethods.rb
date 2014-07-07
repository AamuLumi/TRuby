

module TRuby::GameMethods

	def bombOn(x, y)
		@bombs["#{x}_#{y}"] != nil
	end

	def powerUpOn(x, y)
		@powerups.keys.any? {|key| key == "#{x}_#{y}"}
	end

	def popPowerUp(x, y)
		r = rand(100)

		if (r >= 1 && r <= 10)
			@powerups["#{x}_#{y}"] = TRuby::Fireup.new(x, y, 1)
		elsif (r >= 11 && r <= 20)
			@powerups["#{x}_#{y}"] = TRuby::Bombup.new(x, y, 1)
		elsif (r >= 21 && r <= 25)
			@powerups["#{x}_#{y}"] = TRuby::Timeup.new(x, y, 250)
		elsif (r >= 26 && r <= 30)
			@powerups["#{x}_#{y}"] = TRuby::Timeup.new(x, y, -250)
		end
	end

	def bombExplosion(bomb)
		bomb.explode 

		(1...bomb.power+1).each do |i|
			if (@map.datasValueFor(bomb.x+i, bomb.y) == 1 and (bomb.x()+i) < @map.width)
				@map.changeData(bomb.x+i, bomb.y, 0)
				popPowerUp(bomb.x+i, bomb.y)
			end
			if bombOn(bomb.x+i, bomb.y) and (bomb.x()+i) < @map.width
				bombExplosion(@bombs["#{bomb.x+i}_#{bomb.y}"]) if (!@bombs["#{bomb.x+i}_#{bomb.y}"].exploded)
			end

			if (@map.datasValueFor(bomb.x-i, bomb.y) == 1 and (bomb.x() -i) >= 0)
				@map.changeData(bomb.x-i, bomb.y, 0)
				popPowerUp(bomb.x-i, bomb.y)
			end
			if (bombOn(bomb.x-i, bomb.y)) and (bomb.x() -i) >= 0
				bombExplosion(@bombs["#{bomb.x-i}_#{bomb.y}"]) if (!@bombs["#{bomb.x-i}_#{bomb.y}"].exploded)
			end

			if (@map.datasValueFor(bomb.x, bomb.y+i) == 1 and (bomb.y() + i) < @map.height)
				@map.changeData(bomb.x, bomb.y+i, 0)
				popPowerUp(bomb.x, bomb.y+i)
			end
			if (bombOn(bomb.x, bomb.y+i)) and (bomb.y() + i) < @map.height
				bombExplosion(@bombs["#{bomb.x}_#{bomb.y+i}"]) if (!@bombs["#{bomb.x}_#{bomb.y+i}"].exploded)
			end

			if (@map.datasValueFor(bomb.x, bomb.y-i) == 1 and (bomb.y() -i) >= 0)
				@map.changeData(bomb.x, bomb.y-i, 0)
				popPowerUp(bomb.x, bomb.y-i)
			end
			if (bombOn(bomb.x, bomb.y-i)) and (bomb.y() -i) >= 0
				bombExplosion(@bombs["#{bomb.x}_#{bomb.y-i}"]) if (!@bombs["#{bomb.x}_#{bomb.y-i}"].exploded)
			end
		end

		@bombs.delete("#{bomb.x}_#{bomb.y}")
	end


end