
module TRuby

	class Player

		attr_reader :name, :x, :y, :bombsRemaining, :maxBombs, :bombDuration, :power, :dead, :points

		def initialize(name, x, y, mx, my)
			@name = name
			@x = x
			@y = y
			@mx = mx
			@my = my
			@bombsRemaining = 1
			@maxBombs = 1
			@bombDuration = 3000
			@power = 1
			@dead = false
			@points = 0
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

		def setCoordonates(x, y)
			@x = x
			@y = y
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
			if @bombsRemaining < @maxBombs
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
			oldMaxBomb = @maxBombs

			@maxBombs += n
			@maxBombs = 10 if @maxBombs > 10
			@maxBombs = 1 if @maxBombs < 1

			@bombsRemaining += n
			@bombsRemaining = 10 if @bombsRemaining > 10
			@bombsRemaining = 1 if @bombsRemaining < 1
		end

		def changeDuration(n)
			@bombDuration += n
			@bombDuration = 6000 if @bombDuration > 6000
			@bombDuration = 1000 if @bombDuration < 1000
		end

		def die
			@dead = true
		end

		def live
			@dead = false
		end

		def addPoint
			@points += 1
		end

		def removePoint
			@points -= 1
		end
	end	
end