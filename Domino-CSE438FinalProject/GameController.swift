//
//  GameContoller.swift
//  DominoesOnCommandLine
//
//  Created by Jeanette Rovira on 7/19/21.
//

import Foundation
import UIKit

class GameController {
    
    let onScreen = [CGPoint(x: 5, y: 600), CGPoint(x: 60, y: 600), CGPoint(x: 115, y: 600), CGPoint(x: 170, y: 600),CGPoint(x: 225, y: 600), CGPoint(x: 280, y: 600), CGPoint(x: 335, y: 600)]
    
    let p1OffScreen = [CGPoint(x: 5, y: 1600), CGPoint(x: 60, y: 1600), CGPoint(x: 115, y: 1600), CGPoint(x: 170, y: 1600),CGPoint(x: 225, y: 1600), CGPoint(x: 280, y: 1600), CGPoint(x: 335, y: 1600)]
    let p2OffScreen = [CGPoint(x: 5, y: 2600), CGPoint(x: 60, y: 2600), CGPoint(x: 115, y: 2600), CGPoint(x: 170, y: 2600),CGPoint(x: 225, y: 2600), CGPoint(x: 280, y: 2600), CGPoint(x: 335, y: 2600)]
    let p3OffScreen = [CGPoint(x: 5, y: 3600), CGPoint(x: 60, y: 3600), CGPoint(x: 115, y: 3600), CGPoint(x: 170, y: 3600),CGPoint(x: 225, y: 3600), CGPoint(x: 280, y: 3600), CGPoint(x: 335, y: 3600)]
    let p4OffScreen = [CGPoint(x: 5, y: 4600), CGPoint(x: 60, y: 4600), CGPoint(x: 115, y: 4600), CGPoint(x: 170, y: 4600),CGPoint(x: 225, y: 4600), CGPoint(x: 280, y: 4600), CGPoint(x: 335, y: 4600)]
    
    /**
     This Struct is SUPER important. it keeps track of the most important details in the game board.
     Properties:
     - `tiles`:  are the tiles that have been played.
     - `leftMostSide` is an optional int that starts as nil, but then contains the number of dots on the end of the left side of the train. This is important because your tile must match this variable in order to have a valid move
     - `rightMostSide` same thing as `leftMostSide` but on the right hand side of the train.
     */
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
    var playerIndex = -1
    var team1: Team
    var team2: Team
    var boxOfTiles: [Tile] = []

//    MARK: - init
    init(team1Name: String, team2Name: String, player1Name: String, player2Name: String, player3Name: String, player4Name: String) {
        for i in 0...6 { for j in i...6 { boxOfTiles.append(Tile(int1: i, int2: j, image: UIImage(named: "\(i)\(j)")!, frame: CGRect(origin: CGPoint(x: 5, y: 1600), size: CGSize(width: 50, height: 100)))) }}
        boxOfTiles.shuffle()
        
        self.player1 = Player(name: player1Name, tilesOnHand: Array(boxOfTiles[0...6]))
        self.player2 = Player(name: player2Name, tilesOnHand: Array(boxOfTiles[14...20]))
        self.player3 = Player(name: player3Name, tilesOnHand: Array(boxOfTiles[7...13]))
        self.player4 = Player(name: player4Name, tilesOnHand: Array(boxOfTiles[21...27]))
        self.players = [self.player1, self.player2, self.player3, self.player4]
        
        //move all tiles off screen in rows, p1(y = 1600), p2(y = 2600), p3(y = 3600) p4(y = 4600)
        for i in 0..<players.count{
            player1.getTilesOnHand()[i].updateOriginAsAnchor(point: p1OffScreen[i])
            player2.getTilesOnHand()[i].updateOriginAsAnchor(point: p2OffScreen[i])
            player3.getTilesOnHand()[i].updateOriginAsAnchor(point: p3OffScreen[i])
            player4.getTilesOnHand()[i].updateOriginAsAnchor(point: p4OffScreen[i])
        }
        
        self.team1 = Team(teamName: team1Name, player1: player1, player2: player3)
        self.team2 = Team(teamName: team2Name, player1: player2, player2: player4)
        
        setOrderOfRotation()
    }

    
    
    
//    MARK: Set Order Of Rotation
        /**
         `setOrderOfRotation` checks for who has the double six at the beginning of the first round of the game. That player then becomes the first player of the rotation. This also initializes where the tiles are -> either onscreen or offscreen
         */
        func setOrderOfRotation() {
            for i in 0..<players.count {
                if checkForDoubleSix(player: players[i]) {
                    for j in 0..<7 { players[i].getTilesOnHand()[j].updateOriginAsAnchor(point: onScreen[j])} // if player
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
        
        /**
         - Remark: This function reacts to when the player tries to make a move. it checks whether it is a valid move or not and updates the `Train` (which keeps track of the tiles on the table), the `Player` (which keeps track of the tiles held by each player). If successful, the `playerIndex` gets updated so that it is officially the next player's turn.
         - Parameters:
            - index: Used to specify which tile is going to be thrown. Each player has a property called `tilesInHand: [Tile]` which keeps track of the tiles the player hasn't thrown yet.
            - side: An enum with two cases, `.left` and `.right`. This specifies wether the player wished to throw the specified tile to the left or right  side of the `Train`.
         */
        func getIndexOfTileThatGotPlayed() -> Int? {
            var index = 0
            for tile in players[playerIndex].getTilesOnHand() {
                if tile.playedTo != nil {
                    return index
                }
                index += 1
            }
            return nil
        }
        
        func layDownTile() {
            
            guard let index = getIndexOfTileThatGotPlayed() else { return }

            guard let validLeftMostSide = train.leftMostSide else {
                let tile = players[playerIndex].layDownFirstTile(index: index)
                train.leftMostSide = tile.sides[0]
                train.rightMostSide = tile.sides[1]
                nextPlayerPlease()
                return
            }
            let validRightMostSide = train.rightMostSide!
            
            if players[playerIndex].getTilesOnHand()[index].playedTo == "left" {
                print("played a tile to the left")
                if let newLeftMostSide = players[playerIndex].tryToLayDownTile(dotsOnSide: validLeftMostSide, tileIndex: index){
                    train.leftMostSide = newLeftMostSide
                    nextPlayerPlease()
                }
            } else if players[playerIndex].getTilesOnHand()[index].playedTo == "right" {
                if let newRightMostSide = players[playerIndex].tryToLayDownTile(dotsOnSide: validRightMostSide, tileIndex: index) {
                    train.rightMostSide = newRightMostSide
                    nextPlayerPlease()
                }
            }
        }
    /**
     Checks if the round is over, meaning it checks if a player already layed all tiles or if the game is "stuck" meaning that no player can play any tiles.
     */
    
    // MARK: Player Can't lay down tile.
    
    func roundIsOver() -> Bool {
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
    
    /**
     This function reacts to a player pressing the skipped turn button.
     */
    func skippingPlayersTurn() {
        if !roundIsOver() {
        switch (playerIndex % 2) {
        case 0:
            team1.score += 1
            print("Team 1 Score: \(team1.score), Team 2 Score: \(team2.score)")
        case 1:
            team2.score += 1
            print("Team 1 Score: \(team1.score), Team 2 Score: \(team2.score)")
        default: print("this shouldn't happen")
        }
        nextPlayerPlease()
        } else {
            print("HELP")
        }
    }
    
    func nextPlayerPlease() {
        playerIndex = ((playerIndex + 1) % 4)
    }
}
