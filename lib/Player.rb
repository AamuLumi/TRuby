
module TRuby

	class Player

		attr_reader :x, :y, :bombsRemaining, :bombDuration, :power

		def initialize(x, y, mx, my)
			@x = x
			@y = y
			@mx = mx
			@my = my
			@bombsRemaining = 1
			@maxBomb = 1
			@bombDuration = 3000
			@power = 1
		end

		def move(direction)
			case direction
			when LEFT
				@x -= 1 if @x > 0
			when RIGHT 
				@x += 1 if @x < @mx
			when UP
				@y -= 1 if @y > 0
			when DOWN
				@y += 1 if @y < @my
			end
		end

		def canMove(direction)
			case direction
			when LEFT
				@x > 0
			when RIGHT 
				@x < @mx
			when UP
				@y > 0
			when DOWN
				@y < @my
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