
module TRuby

	LEFT = 0x00
	RIGHT = 0x01
	UP = 0x11
	DOWN = 0x10

	class Player

		attr_reader :x, :y, :bombsRemaining, :bombDuration, :power

		def initialize(window, x, y)
			@x = x
			@y = y
			@mx = window.map.width
			@my = window.map.height
			@tile_size = window.map.tile_size
			@bombsRemaining = 1
			@maxBomb = 1
			@bombDuration = 3000
			@power = 1
		end

		def move(direction)
			case direction
			when LEFT
				@x = (@x -1) if @x > 0
			when RIGHT 
				@x = (@x +1) if @x < @mx
			when UP
				@y = (@y -1) if @y > 0
			when DOWN
				@y = (@y +1) if @y < @my
			end
		end
		
		def hasBomb
			@bombsRemaining > 0
		end

		def putBomb
			if hasBomb then
				@bombsRemaining -=1
			else
				false
			end
		end

		def addBomb
			if @bombsRemaining < @maxBomb
				@bombsRemaining += 1
			else
				false
			end
		end

		def changePower(n)
			@power += n
			@power = 10 if @power > 10
			@power = 1 if @power < 1
		end

		def changeBomb(n)
			oldMaxBomb = @maxBomb

			@maxBomb += n
			@maxBomb = 10 if @maxBomb > 10
			@maxBomb = 1 if @maxBomb < 1

			@bombsRemaining += n
			@bombsRemaining = 10 if @bombsRemaining > 10
			@bombsRemaining = 1 if @bombsRemaining < 1
		end

		def changeDuration(n)
			@bombDuration += n
			@bombDuration = 6000 if @bombDuration > 6000
			@bombDuration = 1000 if @bombDuration < 1000
		end
	end	
end