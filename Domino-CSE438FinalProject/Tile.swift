//
//  TileView.swift
//  Domino-CSE438FinalProject
//
//  Created by Jeanette Rovira on 7/18/21.
//

import UIKit

class Tile : UIView {
    
    //MARK: - Variables
    
    var sides: [Int] = [-1,-1]
    var faceImage: UIImage?
    var playedTo: String = "pending" //state of the tile
    var originalCenter: CGPoint!
    
    //MARK: - Init
    
    init(int1: Int, int2: Int, image: UIImage, frame: CGRect) {
        
        self.sides = [int1, int2]
        self.faceImage = image
        self.originalCenter = CGPoint(x: frame.origin.x + frame.size.width / 2, y: frame.origin.y + frame.size.height / 2)
        super.init(frame: frame)
        
        //handles image of the tile
        let myImage = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        myImage.image = faceImage
        myImage.layer.zPosition = 1
        self.addSubview(myImage)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: - Helper Functions
    
    func updateOriginAsAnchor(point: CGPoint){
        self.frame.origin = point
        self.originalCenter = CGPoint(x: frame.origin.x + frame.size.width / 2, y: frame.origin.y + frame.size.height / 2)
    }
    
    
    
    
}

