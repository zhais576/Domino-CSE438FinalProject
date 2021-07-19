//
//  GameController.swift
//  Domino-CSE438FinalProject
//
//  Created by Jeanette Rovira on 7/18/21.
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
    
    var train = Train()
    var players: [Player] = []
    var playerIndex = 0
    var curPlayer: Player
    var team1: Team
    var team2: Team
    private var boxOfTiles: [Tile] = []

//    MARK: - init
    init(team1Name: String, team2Name: String, player1Name: String, player2Name: String, player3Name: String, player4Name: String) {
        for i in 0...6 { for j in i...6 { boxOfTiles.append(Tile(int1: i, int2: j, image: UIImage(named: "35")!, frame: .zero)) }}
        boxOfTiles.shuffle()
        
        let player1 = Player(name: player1Name, tilesOnHand: Array(boxOfTiles[0...6]))
        players.append(player1)
        
        let player2 = Player(name: player2Name, tilesOnHand: Array(boxOfTiles[14...20]))
        players.append(player2)
        
        let player3 = Player(name: player3Name, tilesOnHand: Array(boxOfTiles[7...13]))
        players.append(player3)
        
        let player4 = Player(name: player4Name, tilesOnHand: Array(boxOfTiles[21...27]))
        players.append(player4)
        
        self.team1 = Team(teamName: team1Name, player1: player1, player2: player3)
        self.team2 = Team(teamName: team1Name, player1: player2, player2: player4)
        
        self.curPlayer = player1
        setOrderOfRotation()
    }

    
    
    
//    MARK: func setOrderOfRotation
    /**
     `setOrderOfRotation` checks for who has the double six at the beginning of the first round of the game. That player then becomes the first player of the rotation.
     */
    func setOrderOfRotation() {
        var i = 0
        for player in players {
            for tile in player.tilesOnHand {
                if tile.sides == [6,6] {
                    curPlayer = player
                    playerIndex = i
                    break
                }
            }
            i += 1
        }
    }
    
    func nextPlayerPlease() {
        playerIndex += 1
        curPlayer = players[playerIndex % 4]
    }
    
//    MARK:  func layDownTile
    
    /**
     `layDownTile` checks wether the desired tile to be layed is valid or not and if the tile is valid, then updates the   `self.train` struct accordingly.
     - Parameter tile: The `Tile` that is being dragged onto the screen.
     - Parameter side: The  `Train.Side` of the screen in which `Tile` is being dragged to. Could be either `.left` or `.right`
     - Returns: A `Bool` that indicates whether tthe desired tile to be layed was valid or not.
     */
    
    func layDownTile(tile: Tile, side: Train.Side) -> Bool {

        if let leftMostSide = train.leftMostSide, let rightMostSide = train.rightMostSide {
            switch side { // checks whether the tile is layed down to the left or to the right.
            
            case .left:
                if tile.sides.contains(leftMostSide) { // check if valid play
                    train.tiles.append(tile)
                    if leftMostSide != tile.sides[0] { // the new leftmostSide of the train either must be different than the previous leftmostside, except in the case of the double-tile is layed down, where it wouldn't really matter which side of the tile becomes the new leftMostSide. That's why i defaulted to side[1].
                        train.leftMostSide = tile.sides[0]
                    } else {
                    train.leftMostSide = tile.sides[1]
                    }
                    nextPlayerPlease()
                    return true
                } else {
                    return false // return false if invalid play
                }
                
            case .right:
                if tile.sides.contains(rightMostSide) {
                    train.tiles.append(tile)
                    if leftMostSide != tile.sides[0] {
                        train.rightMostSide = tile.sides[0]
                    } else {
                    train.rightMostSide = tile.sides[1]
                    }
                    nextPlayerPlease()
                    return true
                } else {
                    return false
                }
            }
            
        }
        
        // Edge CASE: Beggining of game where there are no tiles in the game
        train.tiles.append(tile)
        train.leftMostSide = tile.sides[0]
        train.rightMostSide = tile.sides[1]
        return true
    }
    
//    MARK: - func needsToSkip
    
    /**
     `needsToSkip` checks if `curPlayer` has any tiles that match the left-or-rightmost side of the train. Updates team scores as necessary. Calls nextPlayerPlease() as necesary.
     - Returns: A `Bool` that is `True` if `curPlayer` must skip turn.
     */
    func needsToSkip() -> Bool {
        var actuallyNeedsToSkip = false
        for tile in curPlayer.tilesOnHand {
            if tile.sides.contains(train.leftMostSide!) || tile.sides.contains(train.rightMostSide!) {
                actuallyNeedsToSkip = false
            } else {
                actuallyNeedsToSkip = true
            }
        }
        if actuallyNeedsToSkip {
            if (playerIndex % 2) == 0 {
                team1.incrementScore(by: 1)
            } else {
                team2.incrementScore(by: 1)
            }
            nextPlayerPlease()
        }
        return actuallyNeedsToSkip
    }
    
    

}
