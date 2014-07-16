
module TRuby::Checkers

	### STATE_PLAYING

	def checkPlayers
		@players.each do |p|
			if (p != nil)
				if (@powerups["#{p.x}_#{p.y}"] != nil)
					if (@powerups["#{p.x}_#{p.y}"].class == TRuby::Fireup)
						p.changePower(@powerups["#{p.x}_#{p.y}"].power)
						@powerups.delete("#{p.x}_#{p.y}")
					elsif (@powerups["#{p.x}_#{p.y}"].class == TRuby::Bombup)
						p.changeBomb(@powerups["#{p.x}_#{p.y}"].bomb)
						@powerups.delete("#{p.x}_#{p.y}")
					elsif (@powerups["#{p.x}_#{p.y}"].class == TRuby::Timeup)
						p.changeDuration(@powerups["#{p.x}_#{p.y}"].duration)
						@powerups.delete("#{p.x}_#{p.y}")
					end
				end
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

	def checkExplosions
		@explosions.each do |e|
			if e.isFinished?
				@explosions.delete(e)
			end
		end
	end

end