

module TRuby

	class Bomb

		attr_reader :x, :y, :power, :exploded

		def initialize(player, time)
			@time = time
			@bombDuration = player.bombDuration
			@player = player
			@power = player.power
			@x = player.x
			@y = player.y
			@exploded = false
		end

		def mustExplode(time)
			(time - @time) * 1000.0 > @bombDuration
		end

		def explode
			@exploded = true
			@player.addBomb
		end
	end
end