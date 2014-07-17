
module TRuby

	class Parameter

		attr_reader :name, :value

		def initialize(name, value, min = 0, max = nil)
			@name = name
			@default = value
			@value = value
			@min = min
			@max = max
		end

		def increase
			if (@value != nil)
				if (@value.class == Fixnum)
					@max == nil ? @value += 1 : @value < @max ? @value += 1 : @value
				end
			end
		end

		def decrease
			if (@value != nil)
				if (@value.class == Fixnum)
					@min == nil ? @value -= 1 : @value > @min ? @value -= 1 : @value
				end
			end
		end

		def isString?
			@value.class == String
		end

		def changeValue(value)
			@value = value
		end

		def addToValue(char)
			if @value == nil or @value == @default
				@value = char 
			else
				@value += char
			end
		end

		def removeLastCharToValue()
			if (@value != @default)
				@value = @value[0...(@value.size() -1)]
				@value = @default if @value.empty?
			end
		end
	end
end