//
//  TileView.swift
//  Domino-CSE438FinalProject
//
//  Created by Jeanette Rovira on 7/18/21.
//

import UIKit

class Tile: UIView {
    
    var image: UIImageView?
    var origin: CGPoint?
    let value: TileStruct?
    
    init(side1: Int, side2: Int, originPoint: CGPoint){
        super.init(frame: frame)
        value = TileStruct(side1: side1, side2: side2)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    

}
