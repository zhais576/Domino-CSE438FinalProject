//
//  TutorialVC.swift
//  Domino-CSE438FinalProject
//
//  Created by Jeanette Rovira on 8/1/21.
//

import UIKit

class TutorialVC: UIViewController {
    
    var indx = 1
    var imView: UIImageView!

    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        super.viewDidLoad()
        let imViewFrame = CGRect(x: 0, y: 70, width: view.frame.width, height: view.frame.height - 150)
        imView = UIImageView(frame: imViewFrame)
        imView.image = UIImage(named: "tutorial1")
        view.addSubview(imView)
        
    
        let bckgrnd = UIColor(red: 0.071, green: 0.106, blue: 0.212, alpha: 1.0)
        view.backgroundColor = bckgrnd
        
        let mmButton = UIButton(type: UIButton.ButtonType.system) as UIButton
        mmButton.frame = CGRect(x: 5, y: 40, width: 100, height: 20)
        mmButton.setTitle("< Main Menu", for: UIControl.State.normal)
        mmButton.tintColor = .magenta
        mmButton.addTarget(self, action: #selector(self.toMainMenu(_:)), for: .touchUpInside)
        view.addSubview(mmButton)
        
        let backButton = UIButton(type: UIButton.ButtonType.system) as UIButton
        backButton.frame = CGRect(x: 5, y: imViewFrame.maxY, width: 100, height: 20)
        backButton.setTitle("< back", for: UIControl.State.normal)
        backButton.tintColor = .magenta
        backButton.addTarget(self, action: #selector(self.goBack(_:)), for: .touchUpInside)
        view.addSubview(backButton)
        
        let nextButton = UIButton(type: UIButton.ButtonType.system) as UIButton
        nextButton.frame = CGRect(x: view.frame.width-100, y: imViewFrame.maxY, width: 100, height: 20)
        nextButton.tintColor = .magenta
        nextButton.setTitle("next >", for: UIControl.State.normal)
        nextButton.addTarget(self, action: #selector(self.goForward(_:)), for: .touchUpInside)
        view.addSubview(nextButton)
        
    }
    
    @objc func toMainMenu(_ sender:UIButton!) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func goBack(_ sender:UIButton!) {
        if indx > 1 {
            indx -= 1
            self.imView.image = UIImage(named: "tutorial\(indx)")
        }
    }
    
    @objc func goForward(_ sender: UIButton!) {
        if indx < 6 {
            indx += 1
            self.imView.image = UIImage(named: "tutorial\(indx)")
        }
    }
}
