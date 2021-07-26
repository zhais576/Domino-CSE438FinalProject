//
//  TestViewController.swift
//  Domino-CSE438FinalProject
//
//  Created by Zhai on 7/20/21.
//

import UIKit

class GamePlayViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var left: UILabel!
    @IBOutlet weak var right: UILabel!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var gameOverButton: UIButton!
    @IBOutlet weak var playerTag: UILabel!
    
    //MARK: - Variables
    
    var currentTile: Tile! //the tile being dragged, not necessarily being legalled played
    var gameMaster = GameManager(player1Name: "p1", player2Name: "p2", player3Name: "p3", player4Name: "p4")
    
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
        playerTag.text = "Player: \(gameMaster.players[gameMaster.currentPlayer].name)"
        left.text = "-1"
        right.text = "-1"
        skipButton.isHidden = true
        gameOverButton.isHidden = true
        for tile in gameMaster.boxOfTiles{ //add all tiles to current view
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
            let translation = gesture.translation(in: self.view)
            currentTile.center = CGPoint(x: currentTile.center.x + translation.x, y: currentTile.center.y + translation.y)
            gesture.setTranslation(CGPoint.zero, in: self.view) //set dragging position change
            if gesture.state == UIGestureRecognizer.State.ended{
                //snaps back to place
                currentTile.center = currentTile.originalCenter
                //checks if tile is played in the field, left or right
                if (0...400).contains(gesture.location(in: self.view).y) { //only if the tile is moved to this zone
                    if gesture.location(in: self.view).x < 195 {  //checks played left or right
                        currentTile.playedTo = "left"
                    } else {
                        currentTile.playedTo = "right"
                    }
                    if gameMaster.playTile(tile: currentTile){ //check if tile can be played
                        gameMaster.skipCounter = 0 //reset skipCounter
                        gameMaster.removeTile(tile: currentTile)
                        if gameMaster.players[gameMaster.currentPlayer].tilesOnHand.count == 0{ // player has 0 tiles, game ends
                            gameOverButton.isHidden = false
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
        //update train int
        left.text = String(gameMaster.train.leftEnd)
        right.text = String(gameMaster.train.rightEnd)
        //exchange onboard tiles with new player's tiles
        gameMaster.displayOnScreen(player: gameMaster.currentPlayer)
        //if player cannot play, prompt skip
        if !gameMaster.canPlay(player: gameMaster.currentPlayer){
            skipButton.isHidden = false
        }
    }
    
    
    @IBAction func skipPressed(_ sender: Any) {
        gameMaster.skipCounter += 1
        skipButton.isHidden = true
        if gameMaster.skipCounter == 4{ //skip 4 times, game ends
            gameOverButton.isHidden = false
        }else{ //else current player skip, calls for next player
            gameMaster.displayOffScreen(player: gameMaster.currentPlayer)
            gameMaster.nextPlayer()
            reloadScreen()
        }
    }

    @IBAction func gameOverPressed(_ sender: Any) {
        let scoreVC = ScoreViewController()
        scoreVC.gameMaster = gameMaster
        navigationController?.pushViewController(scoreVC, animated: true)
    }
    
    
}
