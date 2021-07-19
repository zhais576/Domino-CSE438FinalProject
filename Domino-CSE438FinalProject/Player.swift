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
    var tilesOnHand: [Tile]
    init(name: String, tilesOnHand: [Tile]) {
        self.name = name
        self.tilesOnHand = tilesOnHand
    }
    /**
     -Parameter index: the index from the tilesOnHand that was chosen.
     -Returns: The tile that the player would like to attempt
    */
    func wouldLikeToThrow(index: Int) -> Tile {
        return tilesOnHand[index]
    }
}
