//
//  ViewController.swift
//  Domino-CSE438FinalProject
//
//  Created by Zhai on 7/10/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var theGameBoard: GameBoard!
    
    let tile35 = Tile(int1: 3, int2: 5, image: UIImage(named: "35")!,frame: CGRect(x: 182, y: 611, width: 50, height: 100))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = GameController(team1Name: "t1", team2Name: "t2", player1Name: "p1", player2Name: "p2", player3Name: "p3", player4Name: "p4")
        
        view.addSubview(tile35)
    }

    
    

}

