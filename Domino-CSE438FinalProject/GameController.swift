//
//  GameContoller.swift
//  DominoesOnCommandLine
//
//  Created by Jeanette Rovira on 7/19/21.
//

import Foundation
import UIKit

class GameController {
    
    struct Train {
        var tiles: [Tile] = []
        var leftMostSide: Int?
        var rightMostSide: Int?
        enum Side {
            case left, right
        }
    }
    
    struct Team {
        let teamName: String
        let players: [Player]
        var score = 0
        init(teamName: String, player1: Player, player2: Player) {
            self.players = [player1,player2]
            self.teamName = teamName
        }
    }
    
    var doYouNeedToSkip = false
    var train = Train()
    var player1: Player
    var player2: Player
    var player3: Player
    var player4: Player
    var players: [Player]
    var playerIndex = 0
    var team1: Team
    var team2: Team
    var boxOfTiles: [Tile] = []

//    MARK: - init
    init(team1Name: String, team2Name: String, player1Name: String, player2Name: String, player3Name: String, player4Name: String) {
        for i in 0...6 { for j in i...6 { boxOfTiles.append(Tile(int1: i, int2: j, image: UIImage(named: "35")!, frame: .zero)) }}
        boxOfTiles.shuffle()
        
        self.player1 = Player(name: player1Name, tilesOnHand: Array(boxOfTiles[0...6]))
        self.player2 = Player(name: player2Name, tilesOnHand: Array(boxOfTiles[14...20]))
        self.player3 = Player(name: player3Name, tilesOnHand: Array(boxOfTiles[7...13]))
        self.player4 = Player(name: player4Name, tilesOnHand: Array(boxOfTiles[21...27]))
        self.players = [self.player1, self.player2, self.player3, self.player4]
        
        self.team1 = Team(teamName: team1Name, player1: player1, player2: player3)
        self.team2 = Team(teamName: team2Name, player1: player2, player2: player4)
    
        setOrderOfRotation()
    }

    
    
    
//    MARK: func setOrderOfRotation
    /**
     `setOrderOfRotation` checks for who has the double six at the beginning of the first round of the game. That player then becomes the first player of the rotation.
     */
    func setOrderOfRotation() {
        for i in 0..<players.count {
            if checkForDoubleSix(player: players[i]) {
                self.playerIndex = i
            }
        }
    }
    
    func checkForDoubleSix(player: Player) -> Bool {
        for tile in player.getTilesOnHand() {
            if tile.sides == [6,6] {
                return true
            }
        }
        return false
    }
    
    func nextPlayerPlease() {
        playerIndex = ((playerIndex + 1) % 4)
        switch playerIndex {
        case 0:
            self.player1.isCurrentlyPlaying = true
            self.player2.isCurrentlyPlaying = false
            self.player3.isCurrentlyPlaying = false
            self.player4.isCurrentlyPlaying = false
            self.doYouNeedToSkip = self.player1.needsToSkip(leftMost: train.leftMostSide, rightMost: train.rightMostSide)
        case 1:
            self.player1.isCurrentlyPlaying = false
            self.player2.isCurrentlyPlaying = true
            self.player3.isCurrentlyPlaying = false
            self.player4.isCurrentlyPlaying = false
            self.doYouNeedToSkip = self.player2.needsToSkip(leftMost: train.leftMostSide, rightMost: train.rightMostSide)
        case 2:
            self.player1.isCurrentlyPlaying = false
            self.player2.isCurrentlyPlaying = false
            self.player3.isCurrentlyPlaying = true
            self.player4.isCurrentlyPlaying = false
            self.doYouNeedToSkip = self.player3.needsToSkip(leftMost: train.leftMostSide, rightMost: train.rightMostSide)
        case 3:
            self.player1.isCurrentlyPlaying = false
            self.player2.isCurrentlyPlaying = false
            self.player3.isCurrentlyPlaying = false
            self.player4.isCurrentlyPlaying = true
            self.doYouNeedToSkip = self.player4.needsToSkip(leftMost: train.leftMostSide, rightMost: train.rightMostSide)

        default: print("this shouldnt be happening!")
        }
    }
    
    func layDownTile(index: Int, side: Train.Side) {
        guard let validLeftMostSide = train.leftMostSide else {
            layDownFirstTile(index: index)
            return
        }
        
        let validRightMostSide = train.rightMostSide!
        
        switch playerIndex {
        case 0:
            if side == .left {
                if let newLeftMostSide = self.player1.tryToLayDownTile(dotsOnSide: validLeftMostSide, tileIndex: index) {
                    train.leftMostSide = newLeftMostSide
                    nextPlayerPlease()
                }
            } else {
                if let newRightMostSide = self.player1.tryToLayDownTile(dotsOnSide: validRightMostSide, tileIndex: index) {
                    train.rightMostSide = newRightMostSide
                    nextPlayerPlease()
                }
            }
        case 1:
            if side == .left {
                if let newLeftMostSide = self.player2.tryToLayDownTile(dotsOnSide: validLeftMostSide, tileIndex: index) {
                    train.leftMostSide = newLeftMostSide
                    nextPlayerPlease()
                }
            } else {
                if let newRightMostSide = self.player2.tryToLayDownTile(dotsOnSide: validRightMostSide, tileIndex: index) {
                    train.rightMostSide = newRightMostSide
                    nextPlayerPlease()
                }
            }
        case 2:
            if side == .left {
                if let newLeftMostSide = self.player3.tryToLayDownTile(dotsOnSide: validLeftMostSide, tileIndex: index) {
                    train.leftMostSide = newLeftMostSide
                    nextPlayerPlease()
                }
            } else {
                if let newRightMostSide = self.player3.tryToLayDownTile(dotsOnSide: validRightMostSide, tileIndex: index) {
                    train.rightMostSide = newRightMostSide
                    nextPlayerPlease()
                }
            }
        case 3:
            if side == .left {
                if let newLeftMostSide = self.player4.tryToLayDownTile(dotsOnSide: validLeftMostSide, tileIndex: index) {
                    train.leftMostSide = newLeftMostSide
                    nextPlayerPlease()
                }
            } else {
                if let newRightMostSide = self.player4.tryToLayDownTile(dotsOnSide: validRightMostSide, tileIndex: index) {
                    train.rightMostSide = newRightMostSide
                    nextPlayerPlease()
                }
            }
        default: print("this shouldnt be happening")
        }
    }
    
    func layDownFirstTile(index: Int) {
        switch playerIndex {
        case 0:
            let tile = self.player1.removeSelectedTile(index: index)
            train.leftMostSide = tile.sides[0]
            train.rightMostSide = tile.sides[1]
        case 1:
            let tile = self.player2.removeSelectedTile(index: index)
            train.leftMostSide = tile.sides[0]
            train.rightMostSide = tile.sides[1]
        case 2:
            let tile = self.player3.removeSelectedTile(index: index)
            train.leftMostSide = tile.sides[0]
            train.rightMostSide = tile.sides[1]
        case 3:
            let tile = self.player4.removeSelectedTile(index: index)
            train.leftMostSide = tile.sides[0]
            train.rightMostSide = tile.sides[1]
        default: print("this shouldnt be happening")
        }
        nextPlayerPlease()
    }
    
    func checkIfRoundIsOver() -> Bool {
        var skipCount = 0
        
        for player in players {
            if player.needsToSkip(leftMost: train.leftMostSide, rightMost: train.rightMostSide) {
                skipCount += 1
            }
            if player.getTilesOnHand().isEmpty {
                skipCount = 10 // just in case return doesn't work as expected
                print("Somebody layed all tiles")
                return true // somebody layed all tiles
            }
        }
        
        
        if skipCount >= 4 {
            print("Game is stuck!")
            return true // Game is stuck
        } else {
            return false
        }
    }
}
