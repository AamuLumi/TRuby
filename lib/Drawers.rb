

module TRuby::Drawers

	def drawMenu
		printBackgroundMenu
		printSelection
		printItemsMenu
		
	end

	def drawPlaying

		printMap
		
		printPlayers
		printBombs
		printPowerUps
	end

end