//
//  TileView.swift
//  Domino-CSE438FinalProject
//
//  Created by Jeanette Rovira on 7/18/21.
//

import UIKit

class Tile : UIView {
    
    var sides: [Int] = [-1,-1]
    var faceImage: UIImage?
    
    init(int1: Int, int2: Int, image: UIImage, frame: CGRect) {
        self.sides = [int1, int2]
        self.faceImage = image
        super.init(frame: frame)
        
        let myImage = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        myImage.image = faceImage
        myImage.layer.zPosition = 1
        self.addSubview(myImage)
        print("finished new tile")
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
