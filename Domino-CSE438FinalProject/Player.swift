//
//  Player.swift
//  DominoesOnCommandLine
//
//  Created by Jeanette Rovira on 7/19/21.
//

import Foundation
import UIKit
class Player {
    
    var name: String
    let trashCan: CGPoint = CGPoint(x: -1000, y: -1000)
    private var tilesOnHand: [Tile]
    
    init(name: String, tilesOnHand: [Tile]) {
        self.name = name
        self.tilesOnHand = tilesOnHand
    }
    
    func getTilesOnHand() -> [Tile] {
        return tilesOnHand
    }
    
    func needsToSkip(leftMost: Int?, rightMost: Int?) -> Bool {
        guard let validLeftMost = leftMost else { return false }
        let validRightMost = rightMost!
        for tile in tilesOnHand {
            if tile.sides.contains(validLeftMost) || tile.sides.contains(validRightMost) {
                return false
            }
        }
        return true
    }
    
    func tryToLayDownTile(dotsOnSide: Int?, tileIndex: Int) -> Int? {
        //print("player is trying to lay down tile")
        if tilesOnHand[tileIndex].sides[0] == dotsOnSide {
            let newDotsOnSide = tilesOnHand[tileIndex].sides[1]
            tilesOnHand[tileIndex].updateOriginAsAnchor(point: trashCan) // this line move tile out of screen, "deleting" it
            tilesOnHand.remove(at: tileIndex)
            //print("removed tile 1")
            return newDotsOnSide
        } else if tilesOnHand[tileIndex].sides[1] == dotsOnSide {
            let newDotsOnSide = tilesOnHand[tileIndex].sides[0]
            tilesOnHand[tileIndex].updateOriginAsAnchor(point: trashCan) // this line move tile out of screen, "deleting" it
            tilesOnHand.remove(at: tileIndex)
            //print("removed tile 2")
            return newDotsOnSide
        } else {
            return nil
        }
    }
    
    /**
     This fucntion is for laying down the tile in the edge case where the game just began. It basically initiaites the train.
     */
    
    func layDownFirstTile(index: Int) -> Tile {
        let tileToRemove = tilesOnHand[index]
        tilesOnHand[index].updateOriginAsAnchor(point: trashCan) // this line move tile out of screen, "deleting" it
        tilesOnHand.remove(at: index)
        return tileToRemove
    }
    
}

