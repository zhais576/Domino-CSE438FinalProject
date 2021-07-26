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
    var tilesOnHand: [Tile]
    
    init(inputName: String, inputTiles: [Tile]) {
        name = inputName
        tilesOnHand = inputTiles
    }
    
    
}

