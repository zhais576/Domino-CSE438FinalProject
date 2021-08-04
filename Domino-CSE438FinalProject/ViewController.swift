//
//  ViewController.swift
//  Domino-CSE438FinalProject
//
//  Created by Zhai on 7/10/21.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var logoRed: UIImageView!
    @IBOutlet weak var logoBlue: UIImageView!
    @IBOutlet weak var p1TextField: UITextField!
    @IBOutlet weak var p2TextField: UITextField!
    @IBOutlet weak var p3TextField: UITextField!
    @IBOutlet weak var p4TextField: UITextField!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var tutorialButton: UIButton!
    @IBOutlet weak var titleBlue: UILabel!
    @IBOutlet weak var titleRed: UILabel!
    @IBOutlet weak var mainTitle: UILabel!
    
    //MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        navigationController?.setNavigationBarHidden(true, animated: true)//hides navigation bar
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //startButton.isHidden = true
        setupView()
        clearAll() //clears all textfield and user defaults
    }
    
    //MARK: - helper functions
    
    func setupView() {
        let bckgrnd = hexColor(hexInt: 0xFF121B35)
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
                border.borderColor = UIColor.systemTeal.cgColor
                border.shadowColor = UIColor.blue.cgColor
            } else {                                    // is in team 2
                tf?.textColor = pink
                border.borderColor = UIColor.systemPink.cgColor
                border.shadowColor = UIColor.red.cgColor
                
            }
            tf?.layer.addSublayer(border)
        }
        
        //setup start game button
        startButton.layer.cornerRadius = 10
        startButton.layer.shadowColor = startButton.backgroundColor?.cgColor
        startButton.layer.shadowOpacity = 1
        startButton.layer.shadowOffset = .zero
        startButton.layer.shadowRadius = 5
        
        //setup tutorial button
        tutorialButton.layer.cornerRadius = 10
        tutorialButton.layer.shadowColor = tutorialButton.backgroundColor?.cgColor
        tutorialButton.layer.shadowOpacity = 1
        tutorialButton.layer.shadowOffset = .zero
        tutorialButton.layer.shadowRadius = 5
        
        //set title glow
        mainTitle.layer.shadowColor = UIColor.white.cgColor
        mainTitle.layer.shadowOffset = .zero
        mainTitle.layer.shadowRadius = 10
        mainTitle.layer.shadowOpacity = 1
        mainTitle.layer.masksToBounds = false
        mainTitle.layer.shouldRasterize = true
        titleBlue.layer.shadowColor = UIColor.blue.cgColor
        titleBlue.layer.shadowOffset = .zero
        titleBlue.layer.shadowRadius = 10
        titleBlue.layer.shadowOpacity = 1
        titleBlue.layer.masksToBounds = false
        titleBlue.layer.shouldRasterize = true
        titleRed.layer.shadowColor = UIColor.red.cgColor
        titleRed.layer.shadowOffset = .zero
        titleRed.layer.shadowRadius = 10
        titleRed.layer.shadowOpacity = 1
        titleRed.layer.masksToBounds = false
        titleRed.layer.shouldRasterize = true
        
        //set logo glow
        logoBlue.layer.shadowColor = UIColor.blue.cgColor
        logoBlue.layer.shadowOffset = .zero
        logoBlue.layer.shadowRadius = 10
        logoBlue.layer.shadowOpacity = 1
        logoBlue.layer.masksToBounds = false
        logoBlue.layer.shouldRasterize = true
        logoRed.layer.shadowColor = UIColor.red.cgColor
        logoRed.layer.shadowOffset = .zero
        logoRed.layer.shadowRadius = 10
        logoRed.layer.shadowOpacity = 1
        logoRed.layer.masksToBounds = false
        logoRed.layer.shouldRasterize = true
    }
    
    
    @IBAction func how2Play(_ sender: Any) {
        let tutorialVC = TutorialVC()
        navigationController?.pushViewController(tutorialVC, animated: true)
    }
    
    @IBAction func startPressed(_ sender: Any) {
        if isValid(text1: p1TextField.text!, text2: p2TextField.text!, text3: p3TextField.text!, text4: p4TextField.text!){
            //save names to userdefault
            UserDefaultsHandler().encode(data: [p1TextField.text!, p2TextField.text!, p3TextField.text!, p4TextField.text!], whereTo: .playerNames)
            //reset scores in userdefaults
            UserDefaultsHandler().encode(data: 0, whereTo: .team1Score)
            UserDefaultsHandler().encode(data: 0, whereTo: .team2Score)
            let newGame = GamePlayViewController()
            navigationController?.pushViewController(newGame, animated: false)
        }
    }
    
    func clearAll(){
        p1TextField.text = ""
        p2TextField.text = ""
        p3TextField.text = ""
        p4TextField.text = ""
        //also clears the user default saved names
        UserDefaultsHandler().encode(data: ["p1", "p2", "p3", "p4"], whereTo: .playerNames)
    }
    
    func hexColor(hexInt: Int) -> UIColor{
        let red  = CGFloat((hexInt >> 16) & 0xFF) / 255.0
        let green = CGFloat((hexInt >> 8) & 0xFF) / 255.0
        let blue = CGFloat(hexInt & 0xFF) / 255.0
        let alpha = CGFloat((hexInt >> 24) & 0xFF) / 255.0
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    func isValid(text1: String, text2: String, text3: String, text4: String) -> Bool{
        let allNames = [text1, text2, text3, text4]
        for name in allNames{
            if name == ""{
                promptLabel.text = "Please enter all player names"
                return false
            }
            if name.trimmingCharacters(in: .whitespaces).isEmpty{
                promptLabel.text = "Player names cannot be blank"
                return false
            }
            if name.count > 10{
                promptLabel.text = "Player names must be less than 10 characters"
                return false
            }
            for i in 1..<allNames.count{
                if name == allNames[(allNames.firstIndex(of: name)! + i) % 4]{
                    promptLabel.text = "Player names must be different"
                    return false
                }
            }
        }
        return true
    }
    
}

