//
//  GameBoard.swift
//  Domino-CSE438FinalProject
//
//  Created by Zhai on 7/18/21.
//

import UIKit

class GameBoard: UIView {

    var Tiles: [Tile] = [] {
        didSet {
            setNeedsDisplay()
        }
    }

    override func draw(_ rect: CGRect) {
        for item in Tiles {
            item.draw()
        }
    }
    
    func itemAtLocation(_ location: CGPoint) -> Tile? {
        return Tiles.last { $0.contains(point: location) }
    }


}
