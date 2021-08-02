//
//  TutorialVC.swift
//  Domino-CSE438FinalProject
//
//  Created by Jeanette Rovira on 8/1/21.
//

import UIKit

class TutorialVC: UIViewController {
    
    //MARK: - Variables
    var indx = 1
    var imView: UIImageView!
    var backButton: UIButton!
    var nextButton: UIButton!

    //MARK: - Init
    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        super.viewDidLoad()
        setUpView()
    }
    
    //MARK: - HelperFunctions
    
    func setUpView(){
        let imViewFrame = CGRect(x: 0, y: 32, width: 390, height: 780)
        imView = UIImageView(frame: imViewFrame)
        imView.image = UIImage(named: "tutorial1")
        view.addSubview(imView)
        
        let bckgrnd = UIColor(red: 0.071, green: 0.106, blue: 0.212, alpha: 1.0)
        view.backgroundColor = bckgrnd
        
        backButton = UIButton(frame: CGRect(x: -80, y: 342, width: 160, height: 160))
        backButton.setTitle("                 Back", for: UIControl.State.normal)
        backButton.tintColor = .white
        backButton.backgroundColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 0.5)
        backButton.layer.cornerRadius = 15
        backButton.addTarget(self, action: #selector(self.goBack(_:)), for: .touchUpInside)
        view.addSubview(backButton)
        
        nextButton = UIButton(frame: CGRect(x: 310, y: 342, width: 160, height: 160))
        nextButton.setTitle("Next                  ", for: UIControl.State.normal)
        nextButton.tintColor = .white
        nextButton.backgroundColor = backButton.backgroundColor
        nextButton.layer.cornerRadius = 15
        nextButton.addTarget(self, action: #selector(self.goForward(_:)), for: .touchUpInside)
        view.addSubview(nextButton)
        
        displayButton()
    }
    
    @objc func goBack(_ sender:UIButton!) {
        if indx == 1{
            nextButton.isHidden = true
            backButton.isHidden = true
            print("buttons gone")
            self.navigationController?.popViewController(animated: false)
        }
        if indx > 1 {
            indx -= 1
            self.imView.image = UIImage(named: "tutorial\(indx)")
        }
        displayButton()
    }
    
    @objc func goForward(_ sender: UIButton!) {
        if indx < 6 {
            indx += 1
            self.imView.image = UIImage(named: "tutorial\(indx)")
        }
        displayButton()
    }
    
    func displayButton(){
        if indx == 5{
            backButton.isHidden = false
            nextButton.isHidden = true
        }else{
            backButton.isHidden = false
            nextButton.isHidden = false
        }
    }
    
    
}
