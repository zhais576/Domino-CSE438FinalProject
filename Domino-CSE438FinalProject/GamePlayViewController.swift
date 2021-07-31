//
//  TestViewController.swift
//  Domino-CSE438FinalProject
//
//  Created by Zhai on 7/20/21.
//

import UIKit
import AVFoundation
import AudioToolbox
class GamePlayViewController: UIViewController {
    
    //MARK: - Constants
    
    let miniTileRightPositions = [CGPoint(x: 375, y: 120), CGPoint(x: 375, y: 150),CGPoint(x: 375, y: 180), CGPoint(x: 375, y: 210), CGPoint(x: 375, y: 240), CGPoint(x: 375, y: 270), CGPoint(x: 375, y: 300)]
    let miniTileLeftPositions = [CGPoint(x: -35, y: 120), CGPoint(x: -35, y: 150),CGPoint(x: -35, y: 180), CGPoint(x: -35, y: 210), CGPoint(x: -35, y: 240), CGPoint(x: -35, y: 270), CGPoint(x: -35, y: 300)]
    let miniTileUpPositions = [CGPoint(x: 93, y: 75), CGPoint(x: 123, y: 75),CGPoint(x: 153, y: 75), CGPoint(x: 183, y: 75), CGPoint(x: 213, y: 75), CGPoint(x: 243, y: 75), CGPoint(x: 273, y: 75)]
    
    
    //MARK: - Outlets
    
    var team1ScoreLabel: UILabel!
    var team2ScoreLabel: UILabel!
    var skipButton: UIButton!
    var roundOverButton: UIButton!
    var gameOverButton: UIButton!
    var playerTag: UILabel!
    var playerPanel: UIView!
    var statsPanel: UIView!
    var miniTilePanel: UIView!
    var quitButton: UIButton!
    var skipPlayer: AVAudioPlayer!
    var playerPanelGlow: UIView!
    var statsPanelGlow: UIView!
    var entryBlocker: UIButton!
    var leftEndZone: UIView!
    var rightEndZone: UIView!
    var leftEndZoneGlow: UIView!
    var rightEndZoneGlow: UIView!
    
    //MARK: - Variables
    
    var currentTile: Tile! //the tile being dragged, not necessarily being legalled played
    var gameMaster: GameManager = GameManager(player1Name: "p1", player2Name: "p2", player3Name: "p3", player4Name: "p4")
    var team1Score = 0
    var team2Score = 0
    
    //MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let names = UserDefaultsHandler().decode(fromWhere: .playerNames) as? [String] { //replace p1 p2 p3 p4 with real player names
            gameMaster.player1.name = names[0]
            gameMaster.player2.name = names[1]
            gameMaster.player3.name = names[2]
            gameMaster.player4.name = names[3]
        }
        setUpView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //setup audio
        DispatchQueue.global(qos: .background).async{ [self] in
            loadSkipAudio()
            DispatchQueue.main.async {
                skipPlayer.prepareToPlay()
            }
        }
    }
    
    //MARK: - Helper Functions
    
    func setUpView(){
        view.backgroundColor = hexColor(hexInt: 0xFF121B35)
        
        //setup team scores
        team1ScoreLabel = UILabel(frame: CGRect(x: 90, y: 50, width: 130, height: 30))
        team1ScoreLabel.text = "\(gameMaster.player1.name)/\(gameMaster.player3.name): \(UserDefaultsHandler().decode(fromWhere: .team1Score))"
        team1ScoreLabel.textColor = .white
        team1ScoreLabel.textAlignment = .center
        team1ScoreLabel.layer.zPosition = 1
        view.addSubview(team1ScoreLabel)
        team2ScoreLabel = UILabel(frame: CGRect(x: 240, y: 50, width: 130, height: 30))
        team2ScoreLabel.text = "\(gameMaster.player2.name)/\(gameMaster.player4.name): \(UserDefaultsHandler().decode(fromWhere: .team2Score))"
        team2ScoreLabel.textColor = .white
        team2ScoreLabel.textAlignment = .center
        team2ScoreLabel.layer.zPosition = 1
        view.addSubview(team2ScoreLabel)
        
        //setup current player tag
        playerTag = UILabel(frame: CGRect(x: 60, y: 660, width: 374, height: 21))
        playerTag.textColor = .white
        playerTag.layer.zPosition = 1
        view.addSubview(playerTag)
        
        //setup Skip
        skipButton = UIButton(frame: CGRect(x: 0, y: 110, width: 390, height: 530))
        skipButton.backgroundColor = .systemPink
        skipButton.setTitle("No Valid Dominos to Play! \n Tap to Skip Turn", for: .normal)
        skipButton.titleLabel?.lineBreakMode = .byWordWrapping
        skipButton.titleLabel?.textAlignment = .center
        skipButton.addTarget(self, action: #selector(skipPressed), for: .touchUpInside)
        skipButton.layer.zPosition = 1
        view.addSubview(skipButton)
        
        //setup Round Over
        roundOverButton = UIButton(frame: CGRect(x: 0, y: 110, width: 390, height: 530))
        roundOverButton.backgroundColor = .systemBlue
        roundOverButton.setTitle("Round Over \n Tap to View Score", for: .normal)
        skipButton.titleLabel?.lineBreakMode = .byWordWrapping
        skipButton.titleLabel?.textAlignment = .center
        roundOverButton.addTarget(self, action: #selector(roundIsOver), for: .touchUpInside)
        roundOverButton.layer.zPosition = 1
        view.addSubview(roundOverButton)
        
        // setup game Over
        gameOverButton = UIButton(frame: CGRect(x: 146, y: 417, width: 120, height: 120))
        gameOverButton.setTitle("New Game", for: .normal)
        gameOverButton.backgroundColor = .systemBlue
        gameOverButton.addTarget(self, action: #selector(newGamePressed), for: .touchUpInside)
        gameOverButton.layer.zPosition = 2
        view.addSubview(gameOverButton)
        
        //setup player background
        playerPanel = UIView(frame: CGRect(x: 0, y: 700, width: 390, height: 144))
        playerPanel.backgroundColor = hexColor(hexInt: 0xFF121B35)
        playerPanel.layer.zPosition = 0
        drawShadow(view: playerPanel, lineColor: gameMaster.playerColors[gameMaster.currentPlayer], shadowColor: gameMaster.playerColors[gameMaster.currentPlayer])
        playerPanelGlow = UIView(frame: CGRect(x: playerPanel.frame.origin.x - 30, y: playerPanel.frame.origin.y - 2, width: playerPanel.frame.width + 60, height: playerPanel.frame.height))
        playerPanelGlow.backgroundColor = gameMaster.playerColors[gameMaster.currentPlayer]
        playerPanelGlow.layer.shadowColor = gameMaster.playerColors[gameMaster.currentPlayer].cgColor
        playerPanelGlow.layer.shadowOpacity = 1
        playerPanelGlow.layer.shadowOffset = .zero
        playerPanelGlow.layer.shadowRadius = 10
        playerPanelGlow.layer.zPosition = -1
        view.addSubview(playerPanelGlow)
        view.addSubview(playerPanel)
        
        //setup stats background
        statsPanel = UIView(frame: CGRect(x: 0, y: 0, width: 390, height: 110))
        statsPanel.backgroundColor = hexColor(hexInt: 0xFF121B35)
        statsPanel.layer.zPosition = 0
        drawShadow(view: statsPanel, lineColor: gameMaster.playerColors[gameMaster.currentPlayer], shadowColor: gameMaster.playerColors[gameMaster.currentPlayer])
        statsPanelGlow = UIView(frame: CGRect(x: statsPanel.frame.origin.x - 30, y: statsPanel.frame.origin.y - 2, width: statsPanel.frame.width + 60, height: statsPanel.frame.height))
        statsPanelGlow.backgroundColor = gameMaster.playerColors[gameMaster.currentPlayer]
        statsPanelGlow.layer.shadowColor = gameMaster.playerColors[gameMaster.currentPlayer].cgColor
        statsPanelGlow.layer.shadowOpacity = 1
        statsPanelGlow.layer.shadowOffset = .zero
        statsPanelGlow.layer.shadowRadius = 10
        statsPanelGlow.layer.zPosition = 0
        view.addSubview(statsPanelGlow)
        view.addSubview(statsPanel)
        
        //setup miniTile view
        miniTilePanel = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        miniTilePanel.layer.zPosition = -1
        refreshMiniTile()
        view.addSubview(miniTilePanel)
        
        //setup quit button
        quitButton = UIButton(frame: CGRect(x: 30, y: 50, width: 50, height: 30))
        quitButton.setTitle("quit", for: .normal)
        quitButton.backgroundColor = .systemRed
        quitButton.addTarget(self, action: #selector(quitPressed), for: .touchUpInside)
        quitButton.layer.zPosition = 2
        quitButton.isUserInteractionEnabled = true
        view.addSubview(quitButton)
        
        //setup blocker, blocker stops the last user seeing the new user's tiles, until the new user double taps
        entryBlocker = UIButton(frame: CGRect(x: 0, y: 702, width: 390, height: 140))
        entryBlocker.backgroundColor = gameMaster.playerColors[gameMaster.currentPlayer]
        entryBlocker.setTitle("Pass the phone to \(gameMaster.players[gameMaster.currentPlayer].name) \n Double Tap to Continue \n", for: .normal)
        entryBlocker.titleLabel?.lineBreakMode = .byWordWrapping
        entryBlocker.titleLabel?.textAlignment = .center
        entryBlocker.addTarget(self, action: #selector(self.doubleTap), for: .touchDownRepeat)
        entryBlocker.layer.zPosition = 4
        view.addSubview(entryBlocker)
        
        //setup left end zone and right end zone that is possible for a tile to land
        leftEndZone = UIView(frame: CGRect(origin: gameMaster.train.positions.firstPosition, size: CGSize(width: 50, height: 25)))
        leftEndZone.backgroundColor = hexColor(hexInt: 0xFF121B35)
        leftEndZone.layer.zPosition = 1
        drawShadow(view: leftEndZone, lineColor: gameMaster.playerColors[gameMaster.currentPlayer], shadowColor: gameMaster.playerColors[gameMaster.currentPlayer])
        leftEndZone.isHidden = true
        leftEndZoneGlow = UIView(frame: leftEndZone.frame)
        leftEndZoneGlow.backgroundColor = gameMaster.playerColors[gameMaster.currentPlayer]
        leftEndZoneGlow.layer.shadowColor = gameMaster.playerColors[gameMaster.currentPlayer].cgColor
        leftEndZoneGlow.layer.shadowOpacity = 1
        leftEndZoneGlow.layer.shadowOffset = .zero
        leftEndZoneGlow.layer.shadowRadius = 5
        leftEndZoneGlow.layer.zPosition = 0
        leftEndZoneGlow.isHidden = true
        view.addSubview(leftEndZoneGlow)
        view.addSubview(leftEndZone)
        rightEndZone = UIView(frame: CGRect(origin: gameMaster.train.positions.firstPosition, size: CGSize(width: 50, height: 25)))
        rightEndZone.backgroundColor = hexColor(hexInt: 0xFF121B35)
        rightEndZone.layer.zPosition = 1
        drawShadow(view: rightEndZone, lineColor: gameMaster.playerColors[gameMaster.currentPlayer], shadowColor: gameMaster.playerColors[gameMaster.currentPlayer])
        rightEndZone.isHidden = true
        rightEndZoneGlow = UIView(frame: rightEndZone.frame)
        rightEndZoneGlow.backgroundColor = gameMaster.playerColors[gameMaster.currentPlayer]
        rightEndZoneGlow.layer.shadowColor = gameMaster.playerColors[gameMaster.currentPlayer].cgColor
        rightEndZoneGlow.layer.shadowOpacity = 1
        rightEndZoneGlow.layer.shadowOffset = .zero
        rightEndZoneGlow.layer.shadowRadius = 5
        rightEndZoneGlow.layer.zPosition = 0
        rightEndZoneGlow.isHidden = true
        view.addSubview(rightEndZoneGlow)
        view.addSubview(rightEndZone)
        
        //load labels
        playerTag.text = "Player: \(gameMaster.players[gameMaster.currentPlayer].name)"
        skipButton.isHidden = true
        gameOverButton.isHidden = true
        roundOverButton.isHidden = true
        for tile in gameMaster.boxOfTiles{ //add all tiles to current view
            tile.layer.zPosition = 3
            //tile glowing color
            if tile.theme == "pink"{
                tile.layer.shadowColor = UIColor.red.cgColor
            }else if tile.theme == "teal"{
                tile.layer.shadowColor = UIColor.blue.cgColor
            }
            //add gesture to each tiles
            let gesture = UIPanGestureRecognizer(target: self, action: #selector(self.dragging(gesture:)))
            tile.addGestureRecognizer(gesture)
            tile.isUserInteractionEnabled = true
            view.addSubview(tile)
        }
        currentTile = gameMaster.defaultTile //set tile being played to default, aka a custom null
    }
    
    //Dragging gesture added to the tile class
    @objc func dragging(gesture: UIPanGestureRecognizer) {
        currentTile = gameMaster.defaultTile //reset current tile incase it is linked to another tile
        if let selectedTile = gesture.view as? Tile{
            currentTile = selectedTile //select the tile
            self.view.bringSubviewToFront(currentTile)
            let translation = gesture.translation(in: self.view)
            currentTile.center = CGPoint(x: currentTile.center.x + translation.x, y: currentTile.center.y + translation.y)
            gesture.setTranslation(CGPoint.zero, in: self.view) //set dragging position change
            
            if currentTile.possiblePlay.contains("left"){
                leftEndZone.isHidden = false
                leftEndZoneGlow.isHidden = false
            }
            if currentTile.possiblePlay.contains("right"){
                rightEndZone.isHidden = false
                rightEndZoneGlow.isHidden = false
            }
            
            if gesture.state == UIGestureRecognizer.State.ended{
                //turn zone off
                leftEndZone.isHidden = true
                leftEndZoneGlow.isHidden = true
                rightEndZone.isHidden = true
                rightEndZoneGlow.isHidden = true
                //snaps back to place
                currentTile.center = currentTile.originalCenter
                //checks if tile is played in the field, left or right
                if (110...640).contains(gesture.location(in: self.view).y) { //only if the tile is moved to this zone
                    if gesture.location(in: self.view).x < 195 {  //checks played left or right
                        currentTile.playedTo = "left"
                    } else {
                        currentTile.playedTo = "right"
                    }
                    if gameMaster.playTile(tile: currentTile){ //check if tile can be played
                        gameMaster.skipCounter = 0 //reset skipCounter
                        gameMaster.removeTile(tile: currentTile)
                        view.addSubview(gameMaster.train.update(tile: currentTile)) // update train when a tile is removed
                        if gameMaster.players[gameMaster.currentPlayer].tilesOnHand.count == 0{ // player has 0 tiles, game ends
                            roundOverButton.isHidden = false
                        }else{
                            gameMaster.displayOffScreen(player: gameMaster.currentPlayer)
                            gameMaster.nextPlayer()
                            reloadScreen()
                        }
                    }
                }
            }
        }
    }
    
    func reloadScreen(){
        //update current player tag
        playerTag.text = "Player: \(gameMaster.players[gameMaster.currentPlayer].name)"
        //update player panel and stats panel color
        playerPanel.backgroundColor = hexColor(hexInt: 0xFF121B35)
        drawShadow(view: playerPanel, lineColor: gameMaster.playerColors[gameMaster.currentPlayer], shadowColor: gameMaster.shadowColors[gameMaster.currentPlayer])
        playerPanelGlow.backgroundColor = gameMaster.playerColors[gameMaster.currentPlayer]
        playerPanelGlow.layer.shadowColor = gameMaster.playerColors[gameMaster.currentPlayer].cgColor
        statsPanelGlow.backgroundColor = gameMaster.playerColors[gameMaster.currentPlayer]
        statsPanelGlow.layer.shadowColor = gameMaster.playerColors[gameMaster.currentPlayer].cgColor
        drawShadow(view: statsPanel, lineColor: gameMaster.playerColors[gameMaster.currentPlayer], shadowColor: gameMaster.shadowColors[gameMaster.currentPlayer])
        //put on blocker so the tile isnt seen until tapped twice
        entryBlocker.backgroundColor = gameMaster.playerColors[gameMaster.currentPlayer]
        entryBlocker.setTitle("Pass the phone to \(gameMaster.players[gameMaster.currentPlayer].name) \n Double Tap to Continue \n", for: .normal)
        entryBlocker.isHidden = false
        //update all the mini tiles
        refreshMiniTile()
        //update train end check zone
        updateTrainZone()
    }
    
    func refreshMiniTile(){
        for item in miniTilePanel.subviews{
            item.removeFromSuperview()
        }
        gameMaster.nextPlayer()
        for i in 0..<gameMaster.players[gameMaster.currentPlayer].tilesOnHand.count{
            let miniTile = UIImageView(frame: CGRect(x: -100, y: -100, width: 25, height: 50))
            miniTile.image = UIImage(named: "00")
            
            miniTile.layer.shadowColor = gameMaster.shadowColors[gameMaster.currentPlayer].cgColor
            miniTile.layer.shadowRadius = 0.1088 * miniTile.frame.width
            miniTile.layer.shadowOpacity = 0.8
            
            let shade = makeTileTint()
            shade.backgroundColor = gameMaster.shadowColors[gameMaster.currentPlayer]
            miniTile.addSubview(shade)
            
            miniTile.transform = miniTile.transform.rotated(by: -.pi / 2)
            miniTile.frame.origin = miniTileRightPositions[i]
            miniTilePanel.addSubview(miniTile)
        }
        gameMaster.nextPlayer()
        for i in 0..<gameMaster.players[gameMaster.currentPlayer].tilesOnHand.count{
            let miniTile = UIImageView(frame: CGRect(x: -100, y: -100, width: 25, height: 50))
            miniTile.image = UIImage(named: "00")
            
            miniTile.layer.shadowColor = gameMaster.shadowColors[gameMaster.currentPlayer].cgColor
            miniTile.layer.shadowRadius = 0.1088 * miniTile.frame.width
            miniTile.layer.shadowOpacity = 0.8
            
            let shade = makeTileTint()
            shade.backgroundColor = gameMaster.shadowColors[gameMaster.currentPlayer]
            miniTile.addSubview(shade)
            
            miniTile.transform = miniTile.transform.rotated(by: .pi)
            miniTile.frame.origin = miniTileUpPositions[i]
            miniTile.layer.zPosition = -1
            miniTilePanel.addSubview(miniTile)
        }
        gameMaster.nextPlayer()
        for i in 0..<gameMaster.players[gameMaster.currentPlayer].tilesOnHand.count{
            let miniTile = UIImageView(frame: CGRect(x: -100, y: -100, width: 25, height: 50))
            miniTile.image = UIImage(named: "00")
            
            miniTile.layer.shadowColor = gameMaster.shadowColors[gameMaster.currentPlayer].cgColor
            miniTile.layer.shadowRadius = 0.1088 * miniTile.frame.width
            miniTile.layer.shadowOpacity = 0.8
            
            let shade = makeTileTint()
            shade.backgroundColor = gameMaster.shadowColors[gameMaster.currentPlayer]
            miniTile.addSubview(shade)
            
            miniTile.transform = miniTile.transform.rotated(by: .pi / 2)
            miniTile.frame.origin = miniTileLeftPositions[i]
            miniTilePanel.addSubview(miniTile)
        }
        gameMaster.nextPlayer() //return to current player
    }
    
    func makeTileTint() -> UIView{
        let tileTint = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 50))
        tileTint.backgroundColor = .yellow
        tileTint.alpha = 0.5
        tileTint.layer.cornerRadius = 0.1088 * tileTint.frame.width
        tileTint.layer.zPosition = 10
        return tileTint
    }
    
    func loadSkipAudio() {
        let url = Bundle.main.url(forResource: "rip", withExtension: "mp3")!
        do{
            skipPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: nil)
        } catch let error as NSError {
            print(error)
        }
        skipPlayer.numberOfLoops = 0
    }
    
    func hexColor(hexInt: Int) -> UIColor{
        let red  = CGFloat((hexInt >> 16) & 0xFF) / 255.0
        let green = CGFloat((hexInt >> 8) & 0xFF) / 255.0
        let blue = CGFloat(hexInt & 0xFF) / 255.0
        let alpha = CGFloat((hexInt >> 24) & 0xFF) / 255.0
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    func drawShadow(view: UIView, lineColor: UIColor, shadowColor: UIColor, thickness: CGFloat = 2, range: CGFloat = 10) {
        //this function uses CALayer to create shadow on the inside of the UIView to mimic glowing effect
        //this function is modified from "https://stackoverflow.com/a/67839910", credit to <teradyl>
        let size = view.frame.size
        view.clipsToBounds = true

        //clear existing shadows
        if let sublayers = view.layer.sublayers, !sublayers.isEmpty {
            for sublayer in sublayers {
                sublayer.removeFromSuperlayer()
            }
        }

        let topShadowLayer: CALayer = CALayer()
        topShadowLayer.backgroundColor = lineColor.cgColor
        topShadowLayer.position = CGPoint(x: size.width / 2, y: -(size.height / 2) + thickness)
        topShadowLayer.bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        topShadowLayer.shadowColor = shadowColor.cgColor
        topShadowLayer.shadowOffset = CGSize(width: 0, height: 0)
        topShadowLayer.shadowOpacity = 1
        topShadowLayer.shadowRadius = range

        let bottomShadowLayer: CALayer = CALayer()
        bottomShadowLayer.backgroundColor = lineColor.cgColor
        bottomShadowLayer.position = CGPoint(x: size.width / 2, y: size.height + (size.height / 2) - thickness)
        bottomShadowLayer.bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        bottomShadowLayer.shadowColor = shadowColor.cgColor
        bottomShadowLayer.shadowOffset = CGSize(width: 0, height: 0)
        bottomShadowLayer.shadowOpacity = 1
        bottomShadowLayer.shadowRadius = range

        let leftShadowLayer: CALayer = CALayer()
        leftShadowLayer.backgroundColor = lineColor.cgColor
        leftShadowLayer.position = CGPoint(x: -(size.width / 2) + thickness, y: size.height / 2)
        leftShadowLayer.bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        leftShadowLayer.shadowColor = shadowColor.cgColor
        leftShadowLayer.shadowOffset = CGSize(width: 0, height: 0)
        leftShadowLayer.shadowOpacity = 1
        leftShadowLayer.shadowRadius = range

        let rightShadowLayer: CALayer = CALayer()
        rightShadowLayer.backgroundColor = lineColor.cgColor
        rightShadowLayer.position = CGPoint(x: size.width + (size.width / 2) - thickness, y: size.height / 2)
        rightShadowLayer.bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        rightShadowLayer.shadowColor = shadowColor.cgColor
        rightShadowLayer.shadowOffset = CGSize(width: 0, height: 0)
        rightShadowLayer.shadowOpacity = 1
        rightShadowLayer.shadowRadius = range
        
        view.layer.addSublayer(topShadowLayer)
        view.layer.addSublayer(bottomShadowLayer)
        view.layer.addSublayer(leftShadowLayer)
        view.layer.addSublayer(rightShadowLayer)
    }
    
    @objc func doubleTap(){
        entryBlocker.isHidden = true
        //exchange onboard tiles with new player's tiles
        gameMaster.displayOnScreen(player: gameMaster.currentPlayer)
        //if player cannot play, prompt skip
        if !gameMaster.canPlay(player: gameMaster.currentPlayer){
            skipButton.isHidden = false
            skipPlayer.play()
        }
    }
    
    func updateTrainZone(){
        var leftZoneSize = CGSize(width: 25, height: 50)
        if gameMaster.train.positions.leftOrientations[gameMaster.train.leftIterator] == "left" || gameMaster.train.positions.leftOrientations[gameMaster.train.leftIterator] == "right"{
            leftZoneSize = CGSize(width: 50, height: 25)
        }
        leftEndZone.frame.size = leftZoneSize
        leftEndZone.frame.origin = gameMaster.train.positions.leftPositions[gameMaster.train.leftIterator]
        drawShadow(view: leftEndZone, lineColor: gameMaster.playerColors[gameMaster.currentPlayer], shadowColor: gameMaster.playerColors[gameMaster.currentPlayer])
        leftEndZoneGlow.frame = leftEndZone.frame
        leftEndZoneGlow.layer.shadowColor = gameMaster.playerColors[gameMaster.currentPlayer].cgColor
        var rightZoneSize = CGSize(width: 25, height: 50)
        if gameMaster.train.positions.rightOrientations[gameMaster.train.rightIterator] == "left" || gameMaster.train.positions.rightOrientations[gameMaster.train.rightIterator] == "right"{
            rightZoneSize = CGSize(width: 50, height: 25)
        }
        rightEndZone.frame.size = rightZoneSize
        rightEndZone.frame.origin = gameMaster.train.positions.rightPositions[gameMaster.train.rightIterator]
        drawShadow(view: rightEndZone, lineColor: gameMaster.playerColors[gameMaster.currentPlayer], shadowColor: gameMaster.playerColors[gameMaster.currentPlayer])
        rightEndZoneGlow.frame = rightEndZone.frame
        rightEndZoneGlow.layer.shadowColor = gameMaster.playerColors[gameMaster.currentPlayer].cgColor
    }
    
    // MARK: - SKIP PRESSED
    
    @objc func skipPressed() {
        
        skipPlayer.stop()
        skipPlayer.currentTime = 0
        gameMaster.skipCounter += 1
        //Defines the logic for awarding points (to the other team) for skipping your turn.
        if gameMaster.skipCounter == 1 || gameMaster.skipCounter == 3 { // This if statement is here because you can't concede for making your own team-mate skip his/her turn.
            switch gameMaster.currentPlayer {
            case 1, 3: // if members of team 2 skip their turn, team 1 gets some points.
                team1Score += 1
                team1ScoreLabel.text = "\(gameMaster.player1.name)/\(gameMaster.player3.name): \(team1Score)"
                UserDefaultsHandler().encode(data: team1Score, whereTo: .team1Score)
            default:
                team2Score += 1
                team2ScoreLabel.text = "\(gameMaster.player2.name)/\(gameMaster.player4.name): \(team2Score)"
                UserDefaultsHandler().encode(data: team2Score, whereTo: .team2Score)
            }
        }
        skipButton.isHidden = true
        if gameMaster.skipCounter == 4{ //skip 4 times, round ends
            roundOverButton.isHidden = false
        } else if team1Score >= 20 {
            let winningAlert = UIAlertController(title: "team has won with with a score of 20 - \(team2Score)!", message: nil, preferredStyle: .alert)
            winningAlert.addAction(UIAlertAction(title: "Continue", style: .default, handler: nil))
            self.present(winningAlert, animated: true)
            gameOverButton.isHidden = false
        } else if team2Score >= 20 {
            let winningAlert = UIAlertController(title: "team 2 has won with with a score of 20 - \(team1Score)!", message: nil, preferredStyle: .alert)
            winningAlert.addAction(UIAlertAction(title: "Continue", style: .default, handler: nil))
            self.present(winningAlert, animated: true)
            gameOverButton.isHidden = false
        }else { //else current player skip, calls for next player
            gameMaster.displayOffScreen(player: gameMaster.currentPlayer)
            gameMaster.nextPlayer()
            reloadScreen()
        }
    }
    
    // MARK: - GAME OVER PRESSED
    
    @objc func roundIsOver(){
        let scoreVC = ScoreViewController()
        scoreVC.gameMaster = gameMaster
        navigationController?.pushViewController(scoreVC, animated: false)
    }
    
    
    @objc func newGamePressed(){
        restart()
    }
    
    @objc func quitPressed(){
        let quitAlert = UIAlertController(title: "Do you wish to quit?", message: "All progress will be lost.", preferredStyle: .alert)
        quitAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        quitAlert.addAction(UIAlertAction(title: "Quit", style: .default, handler: { action in self.restart() }))
        self.present(quitAlert, animated: true)
    }
    
    func restart(){
        UserDefaultsHandler().encode(data: 0, whereTo: .team1Score)
        UserDefaultsHandler().encode(data: 0, whereTo: .team2Score)
        navigationController?.popToRootViewController(animated: false)
    }
    
    
}
