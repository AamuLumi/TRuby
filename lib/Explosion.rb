

module TRuby

	class Explosion

		attr_reader :positions, :time, :duration

		def initialize(positions, time, duration)
			@time = time
			@positions = positions
			@duration = duration
		end

		def getAlpha
			timed = (Time.now - @time)
			alpha = (255*(@duration/1000 - timed)).to_i
			alpha > 0 ? alpha : 0
		end

		def isFinished?
			(Time.now - @time) * 1000.0 > @duration
		end

	end
end