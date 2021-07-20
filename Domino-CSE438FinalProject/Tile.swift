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
    var originalCenter: CGPoint! //copies the original center after init
    
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
        
        //create and add gesture to the tile
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(self.dragging(gesture:)))
        self.addGestureRecognizer(gesture)
        self.isUserInteractionEnabled = true
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //this handles the dragging gesture
    //tile must be added as a subview
    @objc func dragging(gesture: UIPanGestureRecognizer){
        let translation = gesture.translation(in: self.superview!)
        let tile35 = gesture.view!
        tile35.center = CGPoint(x: tile35.center.x + translation.x, y: tile35.center.y + translation.y)
        gesture.setTranslation(CGPoint.zero, in: self.superview!)
        //when dragging is released
        if gesture.state == UIGestureRecognizer.State.ended{
            //snap back to place
            tile35.center = originalCenter
            //decide the tile is played to the left or right
            playedLeftOrRight(gesture: gesture)
        }
    }
   
    //checks the gesture's location and decide left or right in superview
    func playedLeftOrRight(gesture: UIPanGestureRecognizer){
        if(gesture.location(in: self.superview).x < 195){
            print("Played to the left")
        }else{
            print("Played to the right")
        }
    }
    
    
}
