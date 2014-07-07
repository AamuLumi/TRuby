

module TRuby

	class Powerup

		attr_reader :x, :y

		def initialize(x, y)
			@x = x
			@y = y
		end

	end

	class Fireup < Powerup

		attr_reader :power

		def initialize(x, y, power)
			super(x, y)
			@power = power
		end
	end

	class Bombup < Powerup

		attr_reader :bomb 

		def initialize(x, y, bomb)
			super(x, y)
			@bomb = bomb
		end
	end

	class Timeup < Powerup

		attr_reader :duration

		def initialize(x, y, duration)
			super(x, y)
			@duration = duration
		end
	end

end