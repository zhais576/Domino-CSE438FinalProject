//
//  Player.swift
//  DominoesOnCommandLine
//
//  Created by Jeanette Rovira on 7/19/21.
//

import Foundation
import UIKit
class Player {
    
    //MARK:- Variables
    
    var name: String
    var tilesOnHand: [Tile]
    var team: String
    
    //MARK: - Init
    init(inputName: String, inputTiles: [Tile], myTeam: String) {
        name = inputName
        tilesOnHand = inputTiles
        team = myTeam
    }
    
    
}

