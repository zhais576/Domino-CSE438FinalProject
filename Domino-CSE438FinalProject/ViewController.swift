//
//  ViewController.swift
//  Domino-CSE438FinalProject
//
//  Created by Zhai on 7/10/21.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var p1TextField: UITextField!
    @IBOutlet weak var p2TextField: UITextField!
    @IBOutlet weak var p3TextField: UITextField!
    @IBOutlet weak var p4TextField: UITextField!
    @IBOutlet weak var startButton: UIButton!
    
    //MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true) //hides navigation bar
        startButton.isHidden = true
    }
    
    //MARK: - helper functions
    
    @IBAction func readyPressed(_ sender: Any) { //checks if all names are entered
        if p1TextField.text == "" || p2TextField.text == "" || p3TextField.text == "" || p4TextField.text == ""{
            let namePrompt = UIAlertController(title: "Please enter all names", message: nil, preferredStyle: .alert)
            namePrompt.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(namePrompt, animated: true)
            return
        }
        UserDefaultsHandler().encode(data: [p1TextField.text!, p2TextField.text!, p3TextField.text!, p4TextField.text!], whereTo: .playerNames)
        startButton.isHidden = false //display start button
    }
    
    @IBAction func clearAll(_ sender: Any) {
        p1TextField.text = ""
        p2TextField.text = ""
        p3TextField.text = ""
        p4TextField.text = ""
    }
    
}

