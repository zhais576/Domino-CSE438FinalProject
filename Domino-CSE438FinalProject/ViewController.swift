//
//  ViewController.swift
//  Domino-CSE438FinalProject
//
//  Created by Zhai on 7/10/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var theGameBoard: GameBoard!
    
    let tile35 = Tile(int1: 3, int2: 5, image: UIImage(named: "35")!,frame: CGRect(x: 200, y: 300, width: 50, height: 100))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tile35)
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(ViewController.dragging(gesture:)))
        tile35.addGestureRecognizer(gesture)
        tile35.isUserInteractionEnabled = true
    }

    @objc func dragging(gesture: UIPanGestureRecognizer){
        let originalCenter = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)
        let translation = gesture.translation(in: self.view)
        let tile35 = gesture.view!
        tile35.center = CGPoint(x: tile35.center.x + translation.x, y: tile35.center.y + translation.y)
        gesture.setTranslation(CGPoint.zero, in: self.view)
        if gesture.state == UIGestureRecognizer.State.ended{
            tile35.center = originalCenter
        }
    }
    

}

