
module MapReader

	class Map

		attr_reader :width, :height, :tile_size, :nbPlayers, :isLoaded, :name, :path

		def initialize(name, path)
			@name = name
			@path = path
			@tile_size = DEFAULT_TILE_SIZE
		end

		def readFile
			raise "File not Found" unless (File.exists?(@path))

			f = File.open(@path, "r")
			i = 0
			readData = false
			readSpawns = false
			isLoaded = false

			tmp_nb_spawns = 0

			@width = 0
			@height = 0
			@nbPlayers = 0
			@spawns = Hash.new
			@datas = Hash.new

			f.each_line do |line|
				line = line.chomp

				case line
				when "end_data"
					readData = false
				when "end_spawns"
					readSpawns = false
				end

				if (readData)
					j=0
					line.each_byte do |c|
						@datas[(i*@height)+j] = c.to_i - 48
						j+=1
					end

					i+=1
				elsif (readSpawns)
					@spawns[tmp_nb_spawns] = line
					tmp_nb_spawns += 1
				else
					if line.include?(":")
						tmp = line.split(":") 
						case tmp[0]
						when "players"
							@nbPlayers = tmp[1].to_i
						when "width"
							@width = tmp[1].to_i
						when "height"
							@height = tmp[1].to_i
						when "map_data"
							readData = true
						when "spawns"
							readSpawns = true
						end
					end
				end

			end

			isLoaded = true
			f.close

		end

		def datasValueFor(x, y)
			return @datas[(x*@height) +y]
		end

		def changeData(x, y, value)
			@datas[(x*@height) +y] = value
		end

		def getSpawn(n)
			@spawns[n]
		end

		def getXSpawn(n)
			@spawns[n].split(",")[0].to_i
		end

		def getYSpawn(n)
			@spawns[n].split(",")[1].to_i
		end

	end
end