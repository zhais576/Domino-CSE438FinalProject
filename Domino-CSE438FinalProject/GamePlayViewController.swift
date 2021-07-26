//
//  TestViewController.swift
//  Domino-CSE438FinalProject
//
//  Created by Zhai on 7/20/21.
//

import UIKit

class GamePlayViewController: UIViewController {
    
    var currentTile: Tile!
    
    @IBOutlet weak var left: UILabel!
    @IBOutlet weak var right: UILabel!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var gameOverButton: UIButton!
    
    let gameMaster = GameManager(player1Name: "p1", player2Name: "p2", player3Name: "p3", player4Name: "p4")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    func setUpView(){
        left.text = "-1"
        right.text = "-1"
        skipButton.isHidden = true
        gameOverButton.isHidden = true
        for tile in gameMaster.boxOfTiles{
            view.addSubview(tile)
            let gesture = UIPanGestureRecognizer(target: self, action: #selector(self.dragging(gesture:)))
            tile.addGestureRecognizer(gesture)
            tile.isUserInteractionEnabled = true
        }
        currentTile = gameMaster.defaultTile
    }
    
    //Dragging gesture added to the tile class
    @objc func dragging(gesture: UIPanGestureRecognizer) {
        currentTile = gameMaster.defaultTile
        if let selectedTile = gesture.view as? Tile{
            currentTile = selectedTile
            let translation = gesture.translation(in: self.view)
            currentTile.center = CGPoint(x: currentTile.center.x + translation.x, y: currentTile.center.y + translation.y)
            gesture.setTranslation(CGPoint.zero, in: self.view)
            if gesture.state == UIGestureRecognizer.State.ended{
                //snap back to place
                currentTile.center = currentTile.originalCenter
                //checks if tile is played in the field, left or right
                if (0...400).contains(gesture.location(in: self.view).y) { //only if the tile is moved to this zone
                    if gesture.location(in: self.view).x < 195 {  //checks played left or right
                        currentTile.playedTo = "left"
                    } else {
                        currentTile.playedTo = "right"
                    }
                    if gameMaster.playTile(tile: currentTile){ //check if tile can be played
                        gameMaster.skipCounter = 0
                        gameMaster.removeTile(tile: currentTile)
                        if gameMaster.players[gameMaster.currentPlayer].tilesOnHand.count == 0{
                            gameMaster.gameOver()
                            gameOverButton.isHidden = false
                            skipButton.isHidden = true
                        }
                        gameMaster.displayOffScreen(player: gameMaster.currentPlayer)
                        gameMaster.nextPlayer()
                        reloadScreen()
                    }
                }
            }
        }
    }
    
    func reloadScreen(){
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
        if gameMaster.skipCounter == 4{
            gameMaster.gameOver()
            gameOverButton.isHidden = false
            skipButton.isHidden = true
        }
        gameMaster.displayOffScreen(player: gameMaster.currentPlayer)
        gameMaster.nextPlayer()
        reloadScreen()
    }
    
    
}
