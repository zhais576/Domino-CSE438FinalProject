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
    var faceImage: UIImageView!
    var playedTo: String = "pending" //state of the tile
    var originalCenter: CGPoint!
    var shade: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var theme: String = "white"
    
    //MARK: - Init
    
    init(int1: Int, int2: Int, image: UIImage, frame: CGRect) {
        
        self.sides = [int1, int2]
        self.faceImage = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        self.originalCenter = CGPoint(x: frame.origin.x + frame.size.width / 2, y: frame.origin.y + frame.size.height / 2)
        super.init(frame: frame)
        
        //handles image of the tile
        faceImage.image = image
        faceImage.layer.zPosition = 1
        self.addSubview(faceImage)
        
        //add shade to tile, turn on by default
        shade = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        shade.backgroundColor = .black
        shade.alpha = 0.5
        shade.layer.cornerRadius = 0.1088 * frame.width
        shade.layer.zPosition = 10
        self.addSubview(shade)
        
        //tile 3d shadow
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 0.1088 * self.frame.width
        self.layer.shadowOpacity = 1
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

