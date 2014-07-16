

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

		printExplosions
	end

	def drawWaitingServer
		printWindowMessage("Waiting server ...")
	end

	def drawWaitingClient
		printWindowMessage("Waiting clients ...")
	end

end