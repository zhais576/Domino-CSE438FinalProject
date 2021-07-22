//
//  TestViewController.swift
//  Domino-CSE438FinalProject
//
//  Created by Zhai on 7/20/21.
//

import UIKit

class TestViewController: UIViewController {

    @IBOutlet weak var leftMostDotOutlet: UILabel!
    @IBOutlet weak var rightMostDotOutlet: UILabel!
    @IBOutlet weak var playerLabel: UILabel!
    
    
    let gc = GameController(team1Name: "Team1", team2Name: "Team2", player1Name: "a", player2Name: "b", player3Name: "c", player4Name: "d")

    
    override func viewDidLoad() {
        

        super.viewDidLoad()
        for tile in gc.players[gc.playerIndex].getTilesOnHand() {
            view.addSubview(tile)
        }
        view.setNeedsDisplay()
        
        setVisuals()
    }
    
    
    //the round over button holds the place for roundIsOver function
    func setVisuals(){
        playerLabel.text = "Player: \(gc.playerIndex)"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //print("touch began")
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touches moved")
        for tile in gc.players[gc.playerIndex].getTilesOnHand() {
            if tile.playedTo != nil {
                gc.layDownTile()
                print("lay down tile in vc")
                leftMostDotOutlet.text = String(describing: gc.train.leftMostSide)
                rightMostDotOutlet.text = String(describing: gc.train.rightMostSide)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touches ended")

    }
    
    
}
