//
//  TileView.swift
//  Domino-CSE438FinalProject
//
//  Created by Jeanette Rovira on 7/18/21.
//

import UIKit

class Tile {
    
    let side1: Int
    let side2: Int
    var origin: CGPoint
    var framePath: UIBezierPath = UIBezierPath()
    
    init(side1: Int, side2: Int, origin: CGPoint) {
        self.side1 = side1; self.side2 = side2; self.origin = origin;
    }
    
    func draw() {
        let color: UIColor = .black
        color.setFill()
        let frame = CGRect(origin: self.origin, size: CGSize(width: 30, height: 60))
        framePath = UIBezierPath(roundedRect: frame, cornerRadius: 5)
        framePath.fill()
    }
    
    func contains(point: CGPoint) -> Bool {
            return framePath.contains(point)
        }
    
    
    

}
