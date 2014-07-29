

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

		def inRange(x, y)
			@positions.each do |p|
				puts "#{p} #{x} #{y}"
				if p.split("_")[0].to_i == x and p.split("_")[1].to_i == y
					return true
				end
			end

			false
		end
	end
end