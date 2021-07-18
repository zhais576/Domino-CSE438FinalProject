//
//  ViewController.swift
//  Domino-CSE438FinalProject
//
//  Created by Zhai on 7/10/21.
//

import UIKit

class ViewController: UIViewController {

    var tileBeingPlayed: Tile?
    @IBOutlet weak var theGameBoard: GameBoard!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let tile = Tile(side1: 0, side2: 0, origin: .zero)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard touches.count == 1,
              let touchPoint = touches.first?.location(in: theGameBoard)
        else { return }
        
        if let selectedTile = theGameBoard.itemAtLocation(touchPoint){
            tileBeingPlayed = selectedTile
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard touches.count == 1,
              let touchPoint = touches.first?.location(in: theGameBoard)
        else { return }
        
        tileBeingPlayed?.origin = touchPoint
        theGameBoard.setNeedsDisplay()
    }

}

