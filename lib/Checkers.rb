
module TRuby::Checkers

	### STATE_PLAYING

	def checkPlayers
		if (@powerups["#{@player.x}_#{@player.y}"] != nil)
			if (@powerups["#{@player.x}_#{@player.y}"].class == TRuby::Fireup)
				@player.changePower(@powerups["#{@player.x}_#{@player.y}"].power)
				@powerups.delete("#{@player.x}_#{@player.y}")
			elsif (@powerups["#{@player.x}_#{@player.y}"].class == TRuby::Bombup)
				@player.changeBomb(@powerups["#{@player.x}_#{@player.y}"].bomb)
				@powerups.delete("#{@player.x}_#{@player.y}")
			elsif (@powerups["#{@player.x}_#{@player.y}"].class == TRuby::Timeup)
				@player.changeDuration(@powerups["#{@player.x}_#{@player.y}"].duration)
				@powerups.delete("#{@player.x}_#{@player.y}")
			end
		end
	end

	def checkBombs
		@bombs.each_key do |k|
			if @bombs[k].mustExplode(Time.now) then
				bombExplosion(@bombs[k])
			end
		end
	end
end