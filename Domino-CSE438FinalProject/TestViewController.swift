//
//  TestViewController.swift
//  Domino-CSE438FinalProject
//
//  Created by Zhai on 7/20/21.
//

import UIKit

class TestViewController: UIViewController {

    let tile35 = Tile(int1: 3, int2: 5, image: UIImage(named: "35")!,frame: CGRect(x: 182, y: 611, width: 50, height: 100))
    
    let tile00 = Tile(int1: 0, int2: 0, image: UIImage(named: "00")!,frame: CGRect(x: 300, y: 611, width: 50, height: 100))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tile35)
        view.addSubview(tile00)
    }
    
    //the round over button holds the place for roundIsOver function
    

}
