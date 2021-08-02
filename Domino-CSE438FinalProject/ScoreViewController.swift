//
//  ScoreViewController.swift
//  Domino-CSE438FinalProject
//
//  Created by Zhai on 7/20/21.
//

import UIKit

class ScoreViewController: UIViewController {

    //MARK: - Outlets
    
    var p1DotsLabel: UILabel!
    var p2DotsLabel: UILabel!
    var p3DotsLabel: UILabel!
    var p4DotsLabel: UILabel!
    var roundDotsLabel: UILabel!
    var team1PtsLabel: UILabel!
    var team2PtsLabel: UILabel!
    var newGameButton: UIButton!
    var newRoundButton: UIButton!
    
    //MARK: - Variables
    
    var gameMaster: GameManager!
    var currentTeam1Pts: Int = 0
    var currentTeam2Pts: Int = 0
    var p1Dots: Int = 0
    var p2Dots: Int = 0
    var p3Dots: Int = 0
    var p4Dots: Int = 0
    var totalDots: Int = 0
    var totalPts: Int = 0
    var winningThreshold: Int = 20
    
    //MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = hexColor(hexInt: 0xFF121B35)
        //calculate player dots
        p1Dots = gameMaster.countDot(player: 0)
        p2Dots = gameMaster.countDot(player: 1)
        p3Dots = gameMaster.countDot(player: 2)
        p4Dots = gameMaster.countDot(player: 3)
        //loads previous team scores
        currentTeam1Pts = UserDefaultsHandler().decode(fromWhere: .team1Score) as! Int
        currentTeam2Pts = UserDefaultsHandler().decode(fromWhere: .team2Score) as! Int
        //calculate the points of each player here, load to pts variable
        setUpView()
        addPtsToTeam()
        checkIfTeamWon()
    }
    
    //MARK: - Helper Functions
    
    func setUpView(){
        addImages()
        //set up label
        p1DotsLabel = UILabel(frame: CGRect(x: 30, y: 50, width: 340, height: 30))
        p1DotsLabel.textColor = .white
        p1DotsLabel.font = UIFont(name: "Avenir-Heavy", size: 17.0)
        view.addSubview(p1DotsLabel)
        p2DotsLabel = UILabel(frame: CGRect(x: 30, y: 150, width: 340, height: 30))
        p2DotsLabel.textColor = .white
        p2DotsLabel.font = UIFont(name: "Avenir-Heavy", size: 17.0)
        view.addSubview(p2DotsLabel)
        p3DotsLabel = UILabel(frame: CGRect(x: 30, y: 250, width: 340, height: 30))
        p3DotsLabel.textColor = .white
        p3DotsLabel.font = UIFont(name: "Avenir-Heavy", size: 17.0)
        view.addSubview(p3DotsLabel)
        p4DotsLabel = UILabel(frame: CGRect(x: 30, y: 350, width: 340, height: 30))
        p4DotsLabel.textColor = .white
        p4DotsLabel.font = UIFont(name: "Avenir-Heavy", size: 17.0)
        view.addSubview(p4DotsLabel)
        roundDotsLabel = UILabel(frame: CGRect(x: 145, y: 475, width: 200, height: 30))
        roundDotsLabel.textAlignment = .right
        roundDotsLabel.font = UIFont(name: "Avenir-Heavy", size: 18.0)
        roundDotsLabel.textColor = .white
        view.addSubview(roundDotsLabel)
        team1PtsLabel = UILabel(frame: CGRect(x: 0, y: 540, width: 195, height: 150))
        team1PtsLabel.font = UIFont(name: "ArialRoundedMTBold", size: 30)
        team1PtsLabel.textColor = .systemTeal
        team1PtsLabel.textAlignment = .center
        team1PtsLabel.layer.shadowColor = UIColor.blue.cgColor
        team1PtsLabel.layer.shadowOffset = .zero
        team1PtsLabel.layer.shadowRadius = 10
        team1PtsLabel.layer.shadowOpacity = 1
        team1PtsLabel.layer.masksToBounds = false
        team1PtsLabel.layer.shouldRasterize = true
        view.addSubview(team1PtsLabel)
        team2PtsLabel = UILabel(frame: CGRect(x: 195, y: 540, width: 195, height: 150))
        team2PtsLabel.font = UIFont(name: "ArialRoundedMTBold", size: 30)
        team2PtsLabel.textColor = .systemPink
        team2PtsLabel.textAlignment = .center
        team2PtsLabel.layer.shadowColor = UIColor.red.cgColor
        team2PtsLabel.layer.shadowOffset = .zero
        team2PtsLabel.layer.shadowRadius = 10
        team2PtsLabel.layer.shadowOpacity = 1
        team2PtsLabel.layer.masksToBounds = false
        team2PtsLabel.layer.shouldRasterize = true
        view.addSubview(team2PtsLabel)
        //setup separater
        let separater = UIView(frame: CGRect(x: 30, y: 455, width: 330, height: 3))
        separater.backgroundColor = .orange
        separater.layer.shadowColor = separater.backgroundColor?.cgColor
        separater.layer.shadowOpacity = 1
        separater.layer.shadowOffset = .zero
        separater.layer.shadowRadius = 5
        view.addSubview(separater)
        let staticTotalLabel = UILabel(frame: CGRect(x: 30, y: 475, width: 50, height: 30))
        staticTotalLabel.text = "Total: "
        staticTotalLabel.textColor = .white
        staticTotalLabel.font = UIFont(name: "Avenir-Heavy", size: 18.0)
        view.addSubview(staticTotalLabel)
        let teamBlueLabel = UILabel(frame: CGRect(x: 0, y: 545, width: 195, height: 60))
        teamBlueLabel.text = "Team Blue"
        teamBlueLabel.textColor = .systemTeal
        teamBlueLabel.textAlignment = .center
        teamBlueLabel.font = UIFont(name: "ArialRoundedMTBold", size: 30.0)
        teamBlueLabel.layer.shadowColor = UIColor.blue.cgColor
        teamBlueLabel.layer.shadowOffset = .zero
        teamBlueLabel.layer.shadowRadius = 10
        teamBlueLabel.layer.shadowOpacity = 1
        teamBlueLabel.layer.masksToBounds = false
        teamBlueLabel.layer.shouldRasterize = true
        view.addSubview(teamBlueLabel)
        let teamRedLabel = UILabel(frame: CGRect(x: 195, y: 545, width: 195, height: 60))
        teamRedLabel.text = "Team Red"
        teamRedLabel.textColor = .systemPink
        teamRedLabel.textAlignment = .center
        teamRedLabel.font = UIFont(name: "ArialRoundedMTBold", size: 30.0)
        teamRedLabel.layer.shadowColor = UIColor.red.cgColor
        teamRedLabel.layer.shadowOffset = .zero
        teamRedLabel.layer.shadowRadius = 10
        teamRedLabel.layer.shadowOpacity = 1
        teamRedLabel.layer.masksToBounds = false
        teamRedLabel.layer.shouldRasterize = true
        view.addSubview(teamRedLabel)
        //setup two buttons
        newGameButton = UIButton(frame:CGRect(x: 20, y: 690, width: 350, height: 100))
        newGameButton.layer.cornerRadius = 30
        newGameButton.setTitle("Start New Game", for: .normal)
        newGameButton.titleLabel?.font = UIFont(name: "ArialRoundedMTBold", size: 24.0)
        newGameButton.setTitleColor(.white, for: .normal)
        newGameButton.backgroundColor = .systemGreen
        newGameButton.addTarget(self, action: #selector(newGamePressed), for: .touchUpInside)
        newGameButton.layer.shadowColor = UIColor.green.cgColor
        newGameButton.layer.shadowOpacity = 1
        newGameButton.layer.shadowOffset = .zero
        newGameButton.layer.shadowRadius = 5
        view.addSubview(newGameButton)
        newRoundButton = UIButton(frame:CGRect(x: 20, y: 690, width: 350, height: 100))
        newRoundButton.layer.cornerRadius = 30
        newRoundButton.setTitle(("Start Next Round"), for: .normal)
        newRoundButton.titleLabel?.font = UIFont(name: "ArialRoundedMTBold", size: 24.0)
        newRoundButton.setTitleColor(.white, for: .normal)
        newRoundButton.backgroundColor = .systemGreen
        newRoundButton.addTarget(self, action: #selector(newRoundPressed), for: .touchUpInside)
        newRoundButton.layer.shadowColor = UIColor.green.cgColor
        newRoundButton.layer.shadowOpacity = 1
        newRoundButton.layer.shadowOffset = .zero
        newRoundButton.layer.shadowRadius = 5
        view.addSubview(newRoundButton)
        //set up total dots and points
        totalDots = p1Dots + p2Dots + p3Dots + p4Dots
        
        if totalDots % 10 < 5 {
            totalPts = totalDots/10
        } else {
            totalPts = totalDots/10 + 1
        }
        
        //update dots labels
        p1DotsLabel.text = "Team Blue Player \(gameMaster.player1.name):      \(p1Dots) dots"
        p2DotsLabel.text = "Team Red Player \(gameMaster.player2.name):      \(p2Dots) dots"
        p3DotsLabel.text = "Team Blue Player \(gameMaster.player3.name):      \(p3Dots) dots"
        p4DotsLabel.text = "Team Red Player \(gameMaster.player4.name):      \(p4Dots) dots"
        roundDotsLabel.text = "\(totalDots) dots = \(totalPts) points"
        newGameButton.isHidden = true
        newRoundButton.isHidden = true
    }
    
    func addImages() {
        var xOffset: CGFloat = 0
        var yOffset: CGFloat = 0
        for player in gameMaster.players {
            for tile in player.tilesOnHand {
                let tileImage = UIImageView(frame: CGRect(x: 320 - xOffset, y: 85 + yOffset, width: 25, height: 50))
                if tile.theme == "pink"{
                    tileImage.layer.shadowColor = UIColor.red.cgColor
                }else if tile.theme == "teal"{
                    tileImage.layer.shadowColor = UIColor.blue.cgColor
                }
                tileImage.layer.shadowOpacity = 1
                tileImage.layer.shadowOffset = .zero
                tileImage.layer.shadowRadius = 5
                tileImage.image = tile.faceImage.image
                view.addSubview(tileImage)
                xOffset += 30
            }
            xOffset = 0
            yOffset += 100
        }
    }
    
    func addPtsToTeam(){
        //determine which team has won
        let allDots = [p1Dots, p2Dots, p3Dots, p4Dots]
        if allDots.firstIndex(of: allDots.min()!)! % 2 == 0{ // winning player is 1 or 3
            //add totalPts to team here
            currentTeam1Pts += totalPts
        }else{
            //add totalPts to team here
            currentTeam2Pts += totalPts
        }
        //reset team pts labels
        team1PtsLabel.text = "\(currentTeam1Pts)"
        team2PtsLabel.text = "\(currentTeam2Pts)"
        //update currentTeam1Pts and currentTeam2Pts to userdefault
        UserDefaultsHandler().encode(data: currentTeam1Pts, whereTo: .team1Score)
        UserDefaultsHandler().encode(data: currentTeam2Pts, whereTo: .team2Score)
    }
    
    func checkIfTeamWon(){
        //replace these 2 lines with proper team points
        if currentTeam1Pts >= winningThreshold{
            //team1 win
            let winningAlert = UIAlertController(title: "Team Blue has won!", message: "Team Blue has \(currentTeam1Pts) points!", preferredStyle: .alert)
            winningAlert.addAction(UIAlertAction(title: "Continue", style: .default, handler: nil))
            self.present(winningAlert, animated: true)
            newGameButton.isHidden = false // new game
        }else if currentTeam2Pts >= winningThreshold{
            //team2 win
            let winningAlert = UIAlertController(title: "Team Red has won!", message: "Team Blue has \(currentTeam2Pts) points!", preferredStyle: .alert)
            winningAlert.addAction(UIAlertAction(title: "Continue", style: .default, handler: nil))
            self.present(winningAlert, animated: true)
            newGameButton.isHidden = false //new game
        }else{
            newRoundButton.isHidden = false //neither team meets threshold, new round
        }
    }
    
    @objc func newGamePressed(){
        UserDefaultsHandler().encode(data: 0, whereTo: .team1Score)
        UserDefaultsHandler().encode(data: 0, whereTo: .team2Score)
        navigationController?.popToRootViewController(animated: false)
    }
    
    @objc func newRoundPressed(){
        let newGame = GamePlayViewController()
        newGame.team1Score = self.currentTeam1Pts
        newGame.team2Score = self.currentTeam2Pts
        UserDefaultsHandler().encode(data: self.currentTeam1Pts, whereTo: .team1Score)
        UserDefaultsHandler().encode(data: self.currentTeam2Pts, whereTo: .team2Score)
        navigationController?.pushViewController(newGame, animated: false)
    }

    func hexColor(hexInt: Int) -> UIColor{
        let red  = CGFloat((hexInt >> 16) & 0xFF) / 255.0
        let green = CGFloat((hexInt >> 8) & 0xFF) / 255.0
        let blue = CGFloat(hexInt & 0xFF) / 255.0
        let alpha = CGFloat((hexInt >> 24) & 0xFF) / 255.0
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
}
