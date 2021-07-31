//
//  GameManager.swift
//  TestGamePlay
//
//  Created by Zhai on 7/24/21.
//

import Foundation
import UIKit

class GameManager {
    
    //MARK: - Constants
    
    //all tiles are initialized, relocate current player's to onScreen, the rest off screen
    let onScreen = [CGPoint(x: 5, y: 710), CGPoint(x: 60, y: 710), CGPoint(x: 115, y: 710), CGPoint(x: 170, y: 710),CGPoint(x: 225, y: 710), CGPoint(x: 280, y: 710), CGPoint(x: 335, y: 710)]
    let p1OffScreen = [CGPoint(x: 5, y: 1600), CGPoint(x: 60, y: 1600), CGPoint(x: 115, y: 1600), CGPoint(x: 170, y: 1600),CGPoint(x: 225, y: 1600), CGPoint(x: 280, y: 1600), CGPoint(x: 335, y: 1600)]
    let p2OffScreen = [CGPoint(x: 5, y: 2600), CGPoint(x: 60, y: 2600), CGPoint(x: 115, y: 2600), CGPoint(x: 170, y: 2600),CGPoint(x: 225, y: 2600), CGPoint(x: 280, y: 2600), CGPoint(x: 335, y: 2600)]
    let p3OffScreen = [CGPoint(x: 5, y: 3600), CGPoint(x: 60, y: 3600), CGPoint(x: 115, y: 3600), CGPoint(x: 170, y: 3600),CGPoint(x: 225, y: 3600), CGPoint(x: 280, y: 3600), CGPoint(x: 335, y: 3600)]
    let p4OffScreen = [CGPoint(x: 5, y: 4600), CGPoint(x: 60, y: 4600), CGPoint(x: 115, y: 4600), CGPoint(x: 170, y: 4600),CGPoint(x: 225, y: 4600), CGPoint(x: 280, y: 4600), CGPoint(x: 335, y: 4600)]
    //trashCan is the default move out of screen spot. this DOES NOT delete the tile, use remove(tile) function instead
    let trashCan = CGPoint(x: -1000, y: -1000)
    //placeholder for currentTile
    let defaultTile = Tile(int1: -1, int2: -1, image: UIImage(), frame: CGRect(origin: .zero, size: .zero))
    
    //MARK: - Variables
    
    var currentPlayer: Int = -1
    var player1: Player
    var player2: Player
    var player3: Player
    var player4: Player
    var players: [Player] = []
    var boxOfTiles: [Tile] = []
    var train: Train = Train()
    var skipCounter: Int = 0
    var playerColors: [UIColor] = [.systemTeal, .systemPink, .systemTeal, .systemPink]
    var shadowColors: [UIColor] = [.blue, .red, .blue, .red]
    
    //MARK: - Init
    
    init(player1Name: String, player2Name: String, player3Name: String, player4Name: String) {
        //create all 28 tiles
        for i in 0...6 {
            for j in i...6 {
                let tile = Tile(int1: i, int2: j, image: UIImage(named: "\(i)\(j)")!, frame: CGRect(origin: CGPoint(x: 5, y: 1600), size: CGSize(width: 50, height: 100)))
                boxOfTiles.append(tile)
            }
        }
        //shuffles all tiles
        boxOfTiles.shuffle()
        //create all 4 players each with tiles at hand and add them to the players array
        player1 = Player(inputName: player1Name, inputTiles: Array(boxOfTiles[0...6]))
        player2 = Player(inputName: player2Name, inputTiles: Array(boxOfTiles[14...20]))
        player3 = Player(inputName: player3Name, inputTiles: Array(boxOfTiles[7...13]))
        player4 = Player(inputName: player4Name, inputTiles: Array(boxOfTiles[21...27]))
        players = [player1, player2, player3, player4]
        assignTileColor(player: 0, color: "teal")
        assignTileColor(player: 1, color: "pink")
        assignTileColor(player: 2, color: "teal")
        assignTileColor(player: 3, color: "pink")
        //move all tiles off screen in rows, p1(y = 1600), p2(y = 2600), p3(y = 3600) p4(y = 4600)
        displayOffScreen(player: 1)
        displayOffScreen(player: 2)
        displayOffScreen(player: 3)
        displayOffScreen(player: 4)
        //decide which player goes first, and move first player's tile on screen
        checkFirst()
        // Encode both team's scores to zero
        UserDefaultsHandler().encode(data: 0, whereTo: .team1Score)
        UserDefaultsHandler().encode(data: 0, whereTo: .team2Score)
    }
    
    //MARK: - Helper Functions
    
    func checkFirst(){ //checks for [6,6] and set him as current player
        for i in 0..<players.count{
            if players[i].tilesOnHand.contains(where: { $0.sides == [6,6] }){
                currentPlayer = i
            }
        }
    }
    
    func displayOffScreen(player: Int){ //move player's tile off screen
        if player == 0{
            for i in 0..<players[player].tilesOnHand.count{
                players[player].tilesOnHand[i].updateOriginAsAnchor(point: p1OffScreen[i])
            }
        }else if player == 1{
            for i in 0..<players[player].tilesOnHand.count{
                players[player].tilesOnHand[i].updateOriginAsAnchor(point: p2OffScreen[i])
            }
        }else if player == 2{
            for i in 0..<players[player].tilesOnHand.count{
                players[player].tilesOnHand[i].updateOriginAsAnchor(point: p3OffScreen[i])
            }
        }else if player == 3{
            for i in 0..<players[player].tilesOnHand.count{
                players[player].tilesOnHand[i].updateOriginAsAnchor(point: p4OffScreen[i])
            }
        }
    }
    
    func displayOnScreen(player: Int){ //move player's tile on screen, always shade all tiles
        for i in 0..<players[player].tilesOnHand.count{
            players[player].tilesOnHand[i].updateOriginAsAnchor(point: onScreen[i])
            players[player].tilesOnHand[i].shade.isHidden = false
        }
    }
    
    func playTile(tile: Tile) -> Bool{ //attempts to play a tile, returns true if legal play
        if train.leftEnd == -1{ //first tile ever played in a round
            train.leftEnd = tile.sides[0]
            train.rightEnd = tile.sides[1]
            tile.playedTo = "first"
            return true
        }
        if tile.playedTo == "left"{ //played to the right or left, checks if valid move here.
            if tile.sides.contains(train.leftEnd){ //if can be played to the left
                //update train left end
                if tile.sides[0] == train.leftEnd{
                    train.leftEnd = tile.sides[1]
                }else{
                    train.leftEnd = tile.sides[0]
                }
                return true
            }
        }else if tile.playedTo == "right"{
            if tile.sides.contains(train.rightEnd){ //if can be played to the right
                //update train right end
                if tile.sides[0] == train.rightEnd{
                    train.rightEnd = tile.sides[1]
                }else{
                    train.rightEnd = tile.sides[0]
                }
                //
                return true
            }
        }
        tile.playedTo = "pending"
        return false
    }
    
    //move tile out screen, remove from player hand, add tile to train
    func removeTile(tile:Tile){
        tile.updateOriginAsAnchor(point: trashCan)
        //this line recreates the tileOnHand array without the tile just used, effectively removing it
        players[currentPlayer].tilesOnHand = players[currentPlayer].tilesOnHand.filter { $0 != tile }
        train.tiles.append(tile)
    }
    
    func nextPlayer(){
        if currentPlayer < 3{
            currentPlayer += 1
        }else{
            currentPlayer = 0
        }
    }
    
    func canPlay(player: Int) -> Bool{ //check if the current player has to skip
        var noSkip: Bool = false
        if train.leftEnd == -1{
            for tile in players[player].tilesOnHand{
                tile.shade.isHidden = true
            }
            return true
        }
        for tile in players[player].tilesOnHand{
            if tile.sides.contains(train.leftEnd){
                tile.possiblePlay.append("left")
                noSkip = true
                tile.shade.isHidden = true
            }
            if tile.sides.contains(train.rightEnd){
                tile.possiblePlay.append("right")
                noSkip = true
                tile.shade.isHidden = true
            }
        }
        return noSkip
    }
    
    func countDot(player: Int) -> Int{
        var count = 0
        for tile in players[player].tilesOnHand{
            for side in tile.sides{
                count += side
            }
        }
        return count
    }
    
    func assignTileColor(player: Int, color: String){
        for tile in players[player].tilesOnHand{
            tile.faceImage.image = UIImage(named: color + "\(tile.sides[0])\(tile.sides[1])")
            if color == "pink"{
                tile.theme = "pink"
            }else if color == "teal"{
                tile.theme = "teal"
            }
        }
    }
    
    
}
