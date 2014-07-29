TRuby
=====

Bomberman-like in Ruby 1.9.3 with [Gosu gem](http://www.libgosu.org/).

### How to use it

Before any launch, you need [Gosu](http://www.libgosu.org/).
  > gem install gosu
  
/!\ : Gosu gem stop to ruby 1.9.3, and later versions of Ruby (2.0+) don't work.  
  
You must just launch the "main.rb" file with ruby :
  > ruby main.rb

### Functionalities

  - [x] Network game (auto-launched server via "Create Server" option in main menu)
  - [x] Map Selection and Parameters Selection
  - [x] Power-ups : Bomb-up, Fire-up, Time-up
  - [x] Death implemented
  - [x] Game separated with round

### Must be developped

  - [ ] More power-ups
  - [ ] Balance explosions and death
  - [ ] More icons for players 
  - [ ] Animated players
  - [ ] Timer before launch round
  - [ ] "Win!"/"Lose!" animation when round end
  - [ ] "Player killed" animation when player die
  - [ ] Add notifications (ex: "Connection to host lost") with animation

Known Issues
=====

  - [ ] Can only join a localhost server
  - [ ] Launching the game with one player : the player wins  
    > Solution : set variable @debugMode (l.48 in main.rb) to true  
    > Debug mode block the game to the STATE_PLAYING = no win in this mode

Screenshots
=====

[Screenshot 1 - Main menu](http://serveur1.archive-host.com/membres/up/682970577/TRuby/screenshot1.PNG)  
[Screenshot 2 - Parameters selection](http://serveur1.archive-host.com/membres/up/682970577/TRuby/screeshot2.PNG)  
[Screenshot 3 - In game](http://serveur1.archive-host.com/membres/up/682970577/TRuby/screenshot3.PNG)  
[Screenshot 4 - End round](http://serveur1.archive-host.com/membres/up/682970577/TRuby/screenshot4.PNG)  
