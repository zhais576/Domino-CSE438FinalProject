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
}
