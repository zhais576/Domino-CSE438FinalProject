//
//  Team.swift
//  Domino-CSE438FinalProject
//
//  Created by Jeanette Rovira on 7/18/21.
//

import Foundation
import UIKit

class Team {
    var teamName: String
    let player1: Player
    let player2: Player
    private var score: Int = 0
    
    init(teamName: String, player1: Player, player2: Player) {
        self.teamName = teamName
        self.player1 = player1
        self.player2 = player2
    }
    func getScore() -> Int {
        return score
    }
    func incrementScore(by points: Int) {
        score = score + points
    }
}
