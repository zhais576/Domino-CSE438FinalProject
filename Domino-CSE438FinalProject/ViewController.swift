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
        setupView()
        navigationController?.setNavigationBarHidden(true, animated: false)//hides navigation bar
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //startButton.isHidden = true
        setupView()
        clearAll() //clears all textfield and user defaults
    }
    
    //MARK: - helper functions
    
    func setupView() {
        let bckgrnd = UIColor(red: 0.071, green: 0.106, blue: 0.212, alpha: 1.0)
        let teal = UIColor(red: 0.345, green: 0.773, blue: 0.910, alpha: 1)
        let pink = UIColor(red: 0.827, green: 0.204, blue: 0.459, alpha: 1)
        
        
        
        let textfields = [p1TextField, p2TextField, p3TextField, p4TextField]
        for tf in textfields {
            tf?.backgroundColor = bckgrnd
            tf?.autocorrectionType = .no
            tf?.textAlignment = .center
            
        // setup custom border citation: https://stackoverflow.com/questions/39939557/how-to-customize-uitextfield
            tf?.borderStyle = .none
            let border = CALayer()
            border.frame = CGRect(x: 0, y: 0, width: (tf?.frame.width)!, height: (tf?.frame.height)!)
            
            border.borderWidth = 2.0
            border.shadowRadius = 0.1088 * border.frame.width
            border.shadowOpacity = 1
            
            
            if tf == p1TextField || tf == p3TextField { // is in team 1
                tf?.textColor = teal
                border.borderColor = teal.cgColor
                border.shadowColor = teal.cgColor
            } else {                                    // is in team 2
                tf?.textColor = pink
                border.borderColor = pink.cgColor
                border.shadowColor = pink.cgColor
                
            }
            tf?.layer.addSublayer(border)
            
        }
    }
    
    
    @IBAction func how2Play(_ sender: Any) {
        let tutorialVC = TutorialVC()
        navigationController?.pushViewController(tutorialVC, animated: true)
    }
    
    @IBAction func clearPressed(_ sender: Any) {
        clearAll()
    }
    
    @IBAction func startPressed(_ sender: Any) {
        if p1TextField.text == "" || p2TextField.text == "" || p3TextField.text == "" || p4TextField.text == ""{
            let namePrompt = UIAlertController(title: "Please enter all names", message: nil, preferredStyle: .alert)
            namePrompt.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(namePrompt, animated: true)
            return
        }
        //save names to userdefault
        UserDefaultsHandler().encode(data: [p1TextField.text!, p2TextField.text!, p3TextField.text!, p4TextField.text!], whereTo: .playerNames)
        //reset scores in userdefaults
        UserDefaultsHandler().encode(data: 0, whereTo: .team1Score)
        UserDefaultsHandler().encode(data: 0, whereTo: .team2Score)
        let newGame = GamePlayViewController()
        navigationController?.pushViewController(newGame, animated: false)
    }
    
    func clearAll(){
        p1TextField.text = ""
        p2TextField.text = ""
        p3TextField.text = ""
        p4TextField.text = ""
        //also clears the user default saved names
        UserDefaultsHandler().encode(data: ["p1", "p2", "p3", "p4"], whereTo: .playerNames)
    }
}

