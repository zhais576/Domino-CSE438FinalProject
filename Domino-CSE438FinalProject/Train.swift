//
//  Train.swift
//  Domino-CSE438FinalProject
//
//  Created by Zhai on 7/26/21.
//

import Foundation
import UIKit

struct Train {
    
    //MARK: - Variables
    
    var tiles: [Tile] = []
    var leftEnd: Int = -1
    var rightEnd: Int = -1
    var positions = TrainCoordinates()
    var leftIterator = 0
    var rightIterator = 0
    
    //MARK: - Helper Functions
    
    mutating func update(tile: Tile) -> UIImageView{ //adds UIImageView of the tile to the train
        
        let tileImage = UIImageView(frame: CGRect(x: -1000, y: -1000, width: 25, height: 50)) //initalized to be vertical
        tileImage.image = UIImage(named: "\(tile.sides[0])\(tile.sides[1])")
        
        
        if tile.playedTo == "first"{

            //first image always rotate 90
            tileImage.transform = tileImage.transform.rotated(by: -.pi / 2)
            //draw at first position
            tileImage.frame.origin = positions.firstPosition
            
            
        }else if tile.playedTo == "left"{
            //check train direction
            checkLeftRotation(tile: tile, tileImage: tileImage)
            //draw at left iterator position
            tileImage.frame.origin = positions.leftPositions[leftIterator]
            //increment left iterator
            leftIterator += 1
            
            
        }else if tile.playedTo == "right"{
            //check train direction
            checkRightRotation(tile: tile, tileImage: tileImage)
            //draw at right iterator position
            tileImage.frame.origin = positions.rightPositions[rightIterator]
            //icrement right iterator
            rightIterator += 1
        }
        return tileImage
    }
    
    func checkRightRotation(tile: Tile, tileImage: UIImageView){
        if positions.rightOrientations[rightIterator] == "up"{
            if tile.sides[0] != rightEnd{
                tileImage.transform = tileImage.transform.rotated(by: .pi)
            }
        }else if positions.rightOrientations[rightIterator] == "down"{
            if tile.sides[0] == rightEnd{
                tileImage.transform = tileImage.transform.rotated(by: .pi)
            }
        }else if positions.rightOrientations[rightIterator] == "left"{
            if tile.sides[0] == rightEnd{
                tileImage.transform = tileImage.transform.rotated(by: -.pi / 2)
            }else{
                tileImage.transform = tileImage.transform.rotated(by: .pi / 2)
            }
        }else if positions.rightOrientations[rightIterator] == "right"{
            if tile.sides[0] == rightEnd{
                tileImage.transform = tileImage.transform.rotated(by: .pi / 2)
            }else{
                tileImage.transform = tileImage.transform.rotated(by: -.pi / 2)
            }
        }
    }
    
    func checkLeftRotation(tile: Tile, tileImage: UIImageView){
        if positions.leftOrientations[leftIterator] == "up"{
            if tile.sides[0] != leftEnd{
                tileImage.transform = tileImage.transform.rotated(by: .pi)
            }
        }else if positions.leftOrientations[leftIterator] == "down"{
            if tile.sides[0] == leftEnd{
                tileImage.transform = tileImage.transform.rotated(by: .pi)
            }
        }else if positions.leftOrientations[leftIterator] == "left"{
            if tile.sides[0] == leftEnd{
                tileImage.transform = tileImage.transform.rotated(by: -.pi / 2)
            }else{
                tileImage.transform = tileImage.transform.rotated(by: .pi / 2)
            }
        }else if positions.leftOrientations[leftIterator] == "right"{
            if tile.sides[0] == leftEnd{
                tileImage.transform = tileImage.transform.rotated(by: .pi / 2)
            }else{
                tileImage.transform = tileImage.transform.rotated(by: -.pi / 2)
            }
        }
    }

    
}
