//
//  TestViewController.swift
//  Domino-CSE438FinalProject
//
//  Created by Zhai on 7/20/21.
//

import UIKit

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
    
    //MARK: - Helper Functions
    
    func setUpView(){
        view.backgroundColor = .systemGreen
        
        //setup team scores
        team1ScoreLabel = UILabel(frame: CGRect(x: 40, y: 50, width: 130, height: 30))
        team1ScoreLabel.text = "\(gameMaster.player1.name)/\(gameMaster.player3.name): \(UserDefaultsHandler().decode(fromWhere: .team1Score))"
        team1ScoreLabel.layer.zPosition = 1
        view.addSubview(team1ScoreLabel)
        team2ScoreLabel = UILabel(frame: CGRect(x: 220, y: 50, width: 100, height: 30))
        team2ScoreLabel.text = "\(gameMaster.player2.name)/\(gameMaster.player4.name): \(UserDefaultsHandler().decode(fromWhere: .team2Score))"
        team2ScoreLabel.layer.zPosition = 1
        view.addSubview(team2ScoreLabel)
        
        //setup current player tag
        playerTag = UILabel(frame: CGRect(x: 10, y: 660, width: 374, height: 21))
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
        playerPanel = UIView(frame: CGRect(x: 0, y: 640, width: 390, height: 204))
        playerPanel.backgroundColor = gameMaster.playerColors[gameMaster.currentPlayer]
        playerPanel.layer.zPosition = 0
        view.addSubview(playerPanel)
        
        //setup stats background
        statsPanel = UIView(frame: CGRect(x: 0, y: 0, width: 390, height: 110))
        statsPanel.backgroundColor = .orange
        statsPanel.layer.zPosition = 0
        view.addSubview(statsPanel)
        
        //setup miniTile view
        miniTilePanel = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        miniTilePanel.layer.zPosition = -1
        refreshMiniTile()
        view.addSubview(miniTilePanel)
        
        //load labels
        playerTag.text = "Player: \(gameMaster.players[gameMaster.currentPlayer].name)"
        skipButton.isHidden = true
        gameOverButton.isHidden = true
        roundOverButton.isHidden = true
        for tile in gameMaster.boxOfTiles{ //add all tiles to current view
            tile.layer.zPosition = 3
            view.addSubview(tile)
            let gesture = UIPanGestureRecognizer(target: self, action: #selector(self.dragging(gesture:)))
            tile.addGestureRecognizer(gesture)
            tile.isUserInteractionEnabled = true //add gesture to each tiles
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
            if gesture.state == UIGestureRecognizer.State.ended{
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
        //exchange onboard tiles with new player's tiles
        gameMaster.displayOnScreen(player: gameMaster.currentPlayer)
        //update player panel color
        playerPanel.backgroundColor = gameMaster.playerColors[gameMaster.currentPlayer]
        //update all the mini tiles
        refreshMiniTile()
        //if player cannot play, prompt skip
        if !gameMaster.canPlay(player: gameMaster.currentPlayer){
            skipButton.isHidden = false
        }
    }
    
    func refreshMiniTile(){
        for item in miniTilePanel.subviews{
            item.removeFromSuperview()
        }
        gameMaster.nextPlayer()
        for i in 0..<gameMaster.players[gameMaster.currentPlayer].tilesOnHand.count{
            let miniTile = UIImageView(frame: CGRect(x: -100, y: -100, width: 25, height: 50))
            miniTile.image = UIImage(named: "00")
            miniTile.transform = miniTile.transform.rotated(by: .pi / 2)
            miniTile.frame.origin = miniTileRightPositions[i]
            miniTilePanel.addSubview(miniTile)
        }
        gameMaster.nextPlayer()
        for i in 0..<gameMaster.players[gameMaster.currentPlayer].tilesOnHand.count{
            let miniTile = UIImageView(frame: CGRect(x: -100, y: -100, width: 25, height: 50))
            miniTile.image = UIImage(named: "00")
            miniTile.frame.origin = miniTileUpPositions[i]
            miniTile.layer.zPosition = -1
            miniTilePanel.addSubview(miniTile)
        }
        gameMaster.nextPlayer()
        for i in 0..<gameMaster.players[gameMaster.currentPlayer].tilesOnHand.count{
            let miniTile = UIImageView(frame: CGRect(x: -100, y: -100, width: 25, height: 50))
            miniTile.image = UIImage(named: "00")
            miniTile.transform = miniTile.transform.rotated(by: .pi / 2)
            miniTile.frame.origin = miniTileLeftPositions[i]
            miniTilePanel.addSubview(miniTile)
        }
        gameMaster.nextPlayer() //return to current player
    }
    
    // MARK: - SKIP PRESSED
    
    @objc func skipPressed() {
        print("SKip skip")
        gameMaster.skipCounter += 1
//        Defines the logic for awarding points (to the other team) for skipping your turn.
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
        navigationController?.pushViewController(scoreVC, animated: true)
    }
    
    
    @objc func newGamePressed(){
        UserDefaultsHandler().encode(data: 0, whereTo: .team1Score)
        UserDefaultsHandler().encode(data: 0, whereTo: .team2Score)
        navigationController?.popToRootViewController(animated: true)
    }
}
