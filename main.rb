require 'gosu'

$: << "."

require 'lib/map'
require 'lib/player'
require 'lib/bomb'
require 'lib/powerup'
require "lib/constants"
require "lib/explosion"

require 'lib/gamemethods'
require 'lib/statemanager'
require 'lib/checkers'
require 'lib/drawers'
require 'lib/printers'
require 'lib/updaters'
require 'lib/server'
require 'lib/client'

class Game < Gosu::Window

	include TRuby::GameMethods
	include TRuby::StateManager
	include TRuby::Printers
	include TRuby::Drawers
	include TRuby::Updaters
	include TRuby::Checkers
	include TRuby::Server
	include TRuby::Client

	attr_reader :map

	def initialize(width=WIDTH, height=HEIGHT, actualState=nil)

		super width, height, false

		@moveUp = false
		@moveDown = false
		@moveLeft = false
		@moveRight = false
		@bombPut = false
		@client = nil

		@num_actual_player = 0
		@nbPlayers = 2
		@players = Array.new

		@stateMustBeChanged = false
		@isServer = false
		@initializePlaying = true

		@mut = Mutex.new
		@mutexPlayerDatas = Mutex.new

		@image_window = Gosu::Image.new(self, "img/menu/window.png", false)
		@font_window = Gosu::Font.new(self, "fonts/BlissfulThinking.otf", 18)

		if (actualState == nil)
			@actualState = STATE_MENU
			initializeMenu
		end
	end

	def close
		super

		leaveServer

		if (@isServer)
			stopServer
		end
	end

	def initializeMenu
		 
		self.caption = 'TRuby - Selection'

		@mouseShown = true

		@image_background = Gosu::Image.new(self, "img/menu/background.png", false)
		@image_create_server = Gosu::Image.new(self, "img/menu/item_create_server.png", false)
		@image_join_server = Gosu::Image.new(self, "img/menu/item_join_server.png", false)
		@image_quit = Gosu::Image.new(self, "img/menu/item_quit.png", false)

		@image_selection = Gosu::Image.new(self, "img/menu/selection.png", false)
		@selection = SELECTION_CREATE_SERVER
	end

	def initializePlaying
		puts "[GAME] Init Play"
		@mouseShown = false

		puts "[GAME] Init Map"
		begin
			@map = MapReader::Map.new
		rescue
			puts "[ERROR] error map instance"
		end

		puts "[GAME] Loading map"
		begin
			@map.readFile("maps/maptest.map")
		rescue
			puts "[ERROR] loading map"
		end

		puts "[GAME] Fix title"
		self.caption = 'TRuby - Playing'

		puts "[GAME] Init Images"
		@image_mur = Gosu::Image.new(self, "img/mur.png", false)
		@image_bomb = Gosu::Image.new(self, "img/bomb.png", false)
		@image_void = Gosu::Image.new(self, "img/void.png", false)
		@image_fireup = Gosu::Image.new(self, "img/fireup.png", false)
		@image_bombup = Gosu::Image.new(self, "img/bombup.png", false)
		@image_timeup = Gosu::Image.new(self, "img/timeup.png", false)
		@image_player = Gosu::Image.new(self, "img/player.png", false)
		@image_explosion = Gosu::Image.new(self, "img/explosion.png", false)

		puts "[GAME] Init Variables"

		puts "[GAME] Num_actual_player : #{@num_actual_player}"
		@mutexPlayerDatas.synchronize do
			@player = TRuby::Player.new(@map.getXSpawn(@num_actual_player), @map.getYSpawn(@num_actual_player), @map.width, @map.height)
			@players[@num_actual_player] = @player
			sendPlayerInit(@num_actual_player, @player.x, @player.y)
		end

		@bombs = Hash.new(nil)
		@powerups = Hash.new(nil)
		@explosions = Array.new
		
		@dx = 1.0 * WIDTH / (@map.width * @map.tile_size)
		@dy = 1.0 * HEIGHT / (@map.height * @map.tile_size)

		@initializePlaying = false
	end

	def update
		case getActualState()
		when STATE_MENU
			updateMenu
		when STATE_PLAYING
			updatePlaying
		when STATE_WAITING_SERVER
			updateWaitingServer
		when STATE_WAITING_CLIENT
			updateWaitingClient
		end

		checkState
	end

	def draw
		case getActualState()
		when STATE_MENU
			drawMenu
		when STATE_PLAYING
			drawPlaying
		when STATE_WAITING_SERVER
			drawWaitingServer
		when STATE_WAITING_CLIENT
			drawWaitingClient
		end
	end
end


window = Game.new
window.show