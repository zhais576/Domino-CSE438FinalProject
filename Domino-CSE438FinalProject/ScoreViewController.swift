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
    var roundPtsLabel: UILabel!
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
        self.view.backgroundColor = .white
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
    
    
    
    func setUpView(){
        addImages()
        //set up label
        p1DotsLabel = UILabel(frame: CGRect(x: 30, y: 80, width: 200, height: 30))
        view.addSubview(p1DotsLabel)
        p2DotsLabel = UILabel(frame: CGRect(x: 30, y: 160, width: 200, height: 30))
        view.addSubview(p2DotsLabel)
        p3DotsLabel = UILabel(frame: CGRect(x: 30, y: 240, width: 200, height: 30))
        view.addSubview(p3DotsLabel)
        p4DotsLabel = UILabel(frame: CGRect(x: 30, y: 320, width: 200, height: 30))
        view.addSubview(p4DotsLabel)
        roundDotsLabel = UILabel(frame: CGRect(x: 114, y: 420, width: 200, height: 30))
        view.addSubview(roundDotsLabel)
        roundPtsLabel = UILabel(frame: CGRect(x: 114, y: 480, width: 200, height: 30))
        view.addSubview(roundPtsLabel)
        team1PtsLabel = UILabel(frame: CGRect(x: 80, y: 600, width: 200, height: 50))
        team1PtsLabel.font = UIFont(name: "ArialRoundedMTBold", size: 37)
        view.addSubview(team1PtsLabel)
        team2PtsLabel = UILabel(frame: CGRect(x: 260, y: 600, width: 300, height: 50))
        team2PtsLabel.font = UIFont(name: "ArialRoundedMTBold", size: 37)
        view.addSubview(team2PtsLabel)
        //setup two buttons
        newGameButton = UIButton(frame:CGRect(x: 145, y: 680, width: 100, height: 50))
        newGameButton.setTitle("New Game", for: .normal)
        newGameButton.backgroundColor = .systemGreen
        newGameButton.addTarget(self, action: #selector(newGamePressed), for: .touchUpInside)
        view.addSubview(newGameButton)
        newRoundButton = UIButton(frame:CGRect(x: 145, y: 680, width: 100, height: 50))
        newRoundButton.setTitle(("New Round"), for: .normal)
        newRoundButton.backgroundColor = .systemGreen
        newRoundButton.addTarget(self, action: #selector(newRoundPressed), for: .touchUpInside)
        view.addSubview(newRoundButton)
        
        
        //set up total dots and points
        totalDots = p1Dots + p2Dots + p3Dots + p4Dots
        
        if totalDots % 10 < 5 {
            totalPts = totalDots/10
        } else {
            totalPts = totalDots/10 + 1
        }
        
        //update dots labels
        p1DotsLabel.text = "Player \(gameMaster.player1.name): \(p1Dots) dots"
        p2DotsLabel.text = "Player \(gameMaster.player2.name): \(p2Dots) dots"
        p3DotsLabel.text = "Player \(gameMaster.player3.name): \(p3Dots) dots"
        p4DotsLabel.text = "Player \(gameMaster.player4.name): \(p4Dots) dots"
        roundDotsLabel.text = "Round has \(totalDots) dots"
        roundPtsLabel.text = "Round has \(totalPts) points"
        newGameButton.isHidden = true
        newRoundButton.isHidden = true
    }
    
    func addImages() {
        var xOffset: CGFloat = 0
        var yOffset: CGFloat = 0
        for player in gameMaster.players {
            for tile in player.tilesOnHand {
                let tileImage = UIImageView(frame: CGRect(x: 30 + xOffset, y: 110 + yOffset, width: 25, height: 50))
                tileImage.image = tile.faceImage.image
                view.addSubview(tileImage)
                xOffset += 30
            }
            xOffset = 0
            yOffset += 80
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
        team1PtsLabel.text = String(currentTeam1Pts)
        team2PtsLabel.text = String(currentTeam2Pts)
        //update currentTeam1Pts and currentTeam2Pts to userdefault
        UserDefaultsHandler().encode(data: currentTeam1Pts, whereTo: .team1Score)
        UserDefaultsHandler().encode(data: currentTeam2Pts, whereTo: .team2Score)
    }
    
    func checkIfTeamWon(){
        //replace these 2 lines with proper team points
        if currentTeam1Pts >= winningThreshold{
            //team1 win
            let winningAlert = UIAlertController(title: "team 1  has won with with a score of 20 - \(currentTeam2Pts)!", message: nil, preferredStyle: .alert)
            winningAlert.addAction(UIAlertAction(title: "Continue", style: .default, handler: nil))
            self.present(winningAlert, animated: true)
            newGameButton.isHidden = false // new game
        }else if currentTeam2Pts >= winningThreshold{
            //team2 win
            let winningAlert = UIAlertController(title: "team 2  has won with with a score of 20 - \(currentTeam1Pts)!", message: nil, preferredStyle: .alert)
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

}
