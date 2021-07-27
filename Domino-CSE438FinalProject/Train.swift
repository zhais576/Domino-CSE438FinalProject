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
    
    //MARK: - Helper Functions
    
    
    
    let leftPositions = [CGPoint(x: 170, y: 65), CGPoint(x: 120, y: 65), CGPoint(x: 70, y: 65), CGPoint(x: 20, y: 65), // First One DOWN
                         CGPoint(x: 20, y: 90), CGPoint(x: 20, y: 140), CGPoint(x: 20, y: 190), CGPoint(x: 20, y: 240), CGPoint(x: 20, y: 290), CGPoint(x: 20, y: 340), CGPoint(x: 20, y: 390), CGPoint(x: 20, y: 440), CGPoint(x: 20, y: 490), CGPoint(x: 20, y: 540), CGPoint(x: 20, y: 590) ]
    let rightPositions = [CGPoint(x: 220, y: 65), CGPoint(x: 270, y: 65), CGPoint(x: 320, y: 65), // First One DOWN
                          CGPoint(x: 345, y: 90), CGPoint(x: 345, y: 140), CGPoint(x: 345, y: 190), CGPoint(x: 345, y: 240), CGPoint(x: 345, y: 290), CGPoint(x: 345, y: 340), CGPoint(x: 345, y: 390), CGPoint(x: 345, y: 440), CGPoint(x: 345, y: 490), CGPoint(x: 345, y: 540), CGPoint(x: 345, y: 590) ]
    
    
    
    func drawTiles(){
        var rightIndex = 0
        var leftIndex = 0
        for tile in tiles {
            if leftIndex < 1 {
                tile.center = leftPositions[leftIndex]
                leftIndex += 1
                rightIndex += 1
                
            } else {
                
                if tile.playedTo == "left" {
                    tile.center = leftPositions[leftIndex]
                    leftIndex += 1
                } else {
                    tile.center = rightPositions[rightIndex]
                    rightIndex += 1
                }
                
            }
            
        }
        print(String(describing: tiles[tiles.count-1].frame))
        
    }
    
}
