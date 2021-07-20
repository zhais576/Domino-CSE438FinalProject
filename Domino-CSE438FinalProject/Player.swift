//
//  Player.swift
//  Domino-CSE438FinalProject
//
//  Created by Jeanette Rovira on 7/18/21.
//

import Foundation
import UIKit
class Player {
    var name: String
    private var tilesOnHand: [Tile]
    var isCurrentlyPlaying: Bool = false
    
    init(name: String, tilesOnHand: [Tile]) {
        self.name = name
        self.tilesOnHand = tilesOnHand
    }
    
    func getTilesOnHand() -> [Tile] {
        return tilesOnHand
    }
    
    func removeSelectedTile(index: Int) -> Tile {
        let tileToRemove = tilesOnHand[index]
        tilesOnHand.remove(at: index)
        return tileToRemove
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
    
    func tryToLayDownTile(dotsOnSide: Int, tileIndex: Int) -> Int? {
        if tilesOnHand[tileIndex].sides[0] == dotsOnSide {
            let newDotsOnSide = tilesOnHand[tileIndex].sides[1]
            tilesOnHand.remove(at: tileIndex)
            return newDotsOnSide
        } else if tilesOnHand[tileIndex].sides[1] == dotsOnSide {
            let newDotsOnSide = tilesOnHand[tileIndex].sides[0]
            tilesOnHand.remove(at: tileIndex)
            return newDotsOnSide
        } else {
            return nil
        }
    }
}
