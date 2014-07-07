require 'gosu'

$: << "."

require 'lib/map'
require 'lib/player'
require 'lib/bomb'
require 'lib/powerup'
require "lib/constants"

require 'lib/gamemethods'
require 'lib/statemanager'
require 'lib/checkers'
require 'lib/drawers'
require 'lib/printers'
require 'lib/updaters'

class Game < Gosu::Window

	include TRuby::GameMethods
	include TRuby::StateManager
	include TRuby::Printers
	include TRuby::Drawers
	include TRuby::Updaters
	include TRuby::Checkers

	attr_reader :map

	def initialize(width=WIDTH, height=HEIGHT, actualState=nil)

		super width, height, false

		if (actualState == nil)
			@actualState = STATE_MENU
			initializeMenu
		end
	end

	def initializeMenu
		 
		self.caption = 'TRuby - Selection'

		@mouseShown = true

		@image_background = Gosu::Image.new(self, "img/menu/background.png", false)
		@image_play = Gosu::Image.new(self, "img/menu/item_play.png", false)
		@image_quit = Gosu::Image.new(self, "img/menu/item_quit.png", false)

		@image_selection = Gosu::Image.new(self, "img/menu/selection.png", false)
		@selection = SELECTION_PLAY
	end

	def initializePlaying
		@mouseShown = false

		@map = MapReader::Map.new
		@map.readFile("maps/maptest.map")

		self.caption = 'TRuby - Playing'

		@image_mur = Gosu::Image.new(self, "img/mur.png", false)
		@image_bomb = Gosu::Image.new(self, "img/bomb.png", false)
		@image_void = Gosu::Image.new(self, "img/void.png", false)
		@image_fireup = Gosu::Image.new(self, "img/fireup.png", false)
		@image_bombup = Gosu::Image.new(self, "img/bombup.png", false)
		@image_timeup = Gosu::Image.new(self, "img/timeup.png", false)
		@image_player = Gosu::Image.new(self, "img/player.png", false)

		@players = Array.new

		@player = TRuby::Player.new(self, @map.getXSpawn(0), @map.getYSpawn(0))
		@bombs = Hash.new(nil)
		@powerups = Hash.new(nil)
		
		@dx = 1.0 * WIDTH / (@map.width * @map.tile_size)
		@dy = 1.0 * HEIGHT / (@map.height * @map.tile_size)
	end

	def update
		if (@actualState == STATE_MENU)
			updateMenu
		elsif (@actualState == STATE_PLAYING)
			updatePlaying
		end
	end

	def draw
		if (@actualState == STATE_MENU)
			drawMenu
		elsif (@actualState == STATE_PLAYING)
			drawPlaying
		end
	end


end


window = Game.new
window.show