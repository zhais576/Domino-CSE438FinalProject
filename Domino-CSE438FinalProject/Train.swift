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
    
    
    
    let leftPositions = [CGPoint(x: 195, y: 300),
                         CGPoint(x: 145, y: 300),
                         CGPoint(x: 95, y: 300),// TURN DOWN
                         CGPoint(x: 95, y: 325),
                         CGPoint(x: 95, y: 375),
                         CGPoint(x: 95, y: 425),
                         CGPoint(x: 95, y: 475),
                         CGPoint(x: 120, y: 525)] // TURN LEFT ONE THEN UP ONE
    
    
    let rightPositions = [CGPoint(x: 245, y: 300),
                         CGPoint(x: 295, y: 300), // TURN DOWN
                         CGPoint(x: 295, y: 325),
                         CGPoint(x: 295, y: 375),
                         CGPoint(x: 295, y: 425),
                         CGPoint(x: 295, y: 475),
                         CGPoint(x: 295, y: 525)] // TURN LEFT ONE THEN UP ONE
    
    
    
    func drawTiles(){
        var rightIndex = 0
        var leftIndex = 0
        for tile in tiles {
            if leftIndex < 1 { // FIRST TILE EDGE CASE
                tile.center = leftPositions[leftIndex]
                leftIndex += 1
                
            } else {
                
                if tile.playedTo == "left" {
                    
                    tile.center = leftPositions[leftIndex]
                    leftIndex += 1
                } else {
                    
                    if rightIndex < 3 {
                        
                    }
                    tile.center = rightPositions[rightIndex]
                    rightIndex += 1
                }
                
            }
            
        }
        print(String(describing: tiles[tiles.count-1].frame))
        
    }
    
}
