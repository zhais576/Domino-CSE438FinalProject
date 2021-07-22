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
    let gc = GameController(team1Name: "Team1", team2Name: "Team2", player1Name: "a", player2Name: "b", player3Name: "c", player4Name: "d")
    
    let tile35 = Tile(int1: 3, int2: 5, image: UIImage(named: "35")!,frame: CGRect(x: 182, y: 611, width: 50, height: 100))
    
    let tile00 = Tile(int1: 0, int2: 0, image: UIImage(named: "00")!,frame: CGRect(x: 300, y: 611, width: 50, height: 100))
    
    override func viewDidLoad() {
        
        print("load")
        super.viewDidLoad()
        for tile in gc.players[gc.playerIndex].getTilesOnHand() {
            print("added tile to : \(tile.frame)")
            view.addSubview(tile)
        }
        view.setNeedsDisplay()
    }
    
    //the round over button holds the place for roundIsOver function
    

}
