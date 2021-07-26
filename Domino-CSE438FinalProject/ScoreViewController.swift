//
//  ScoreViewController.swift
//  Domino-CSE438FinalProject
//
//  Created by Zhai on 7/20/21.
//

import UIKit

class ScoreViewController: UIViewController {

    var currentTeam1Pts: Int = 10
    var currentTeam2Pts: Int = 0
    var p1Dots: Int = 0
    var p2Dots: Int = 0
    var p3Dots: Int = 0
    var p4Dots: Int = 0
    var totalDots: Int = 0
    var totalPts: Int = 0
    var winningThreshold: Int = 20

    @IBOutlet weak var p1DotsLabel: UILabel!
    @IBOutlet weak var p2DotsLabel: UILabel!
    @IBOutlet weak var p3DotsLabel: UILabel!
    @IBOutlet weak var p4DotsLabel: UILabel!
    @IBOutlet weak var totalDotsLabel: UILabel!
    @IBOutlet weak var totalPtsLabel: UILabel!
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var newRoundButton: UIButton!
    @IBOutlet weak var currentTeam1PtsLabel: UILabel!
    @IBOutlet weak var currentTeam2PtsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO: change player dots here
        //calculate the points of each player here, load to pts variable
        p1Dots = 40
        p2Dots = 30
        p3Dots = 30
        p4Dots = 0
        
        setUpView()
        addPtsToTeam()
        checkIfTeamWon()
        
    }
    
    func setUpView(){
        totalDots = p1Dots + p2Dots + p3Dots + p4Dots
        totalPts = Int(round(Double(totalDots / 10)))
        //update dots labels
        p1DotsLabel.text = String(p1Dots)
        p2DotsLabel.text = String(p2Dots)
        p3DotsLabel.text = String(p3Dots)
        p4DotsLabel.text = String(p4Dots)
        totalDotsLabel.text = String(totalDots)
        totalPtsLabel.text = String(totalPts)
        newGameButton.isHidden = true
        newRoundButton.isHidden = true
    }
    
    func addPtsToTeam(){
        //add totalPts to team here
        //TODO: find the winning team, default here to team 2
        currentTeam2Pts += totalPts
        print("added \(totalPts) to the winning team (default to team 2)")
        print("(default to team 2) has \(currentTeam2Pts)")
        currentTeam1PtsLabel.text = String(currentTeam1Pts)
        currentTeam2PtsLabel.text = String(currentTeam2Pts)
    }
    
    //if team points exceed winningThreshold 20
    //        display winning message
    //        game ends, game controller resets
    //        go back to team name aka ViewController class
    //if neither of the team wins,
    func checkIfTeamWon(){
        //replace these 2 lines with proper team points
        if currentTeam1Pts >= winningThreshold{
            //team1 win
            winningDisplay(team: "Team 1") //replace with team names
            newGameButton.isHidden = false
        }else if currentTeam2Pts >= winningThreshold{
            //team2 win
            winningDisplay(team: "Team 2") //replace with team names
            newGameButton.isHidden = false
        }else{
            //game not end, next round
            newRoundButton.isHidden = false
        }
    }
    
    func winningDisplay(team: String){
        let winningAlert = UIAlertController(title: team + " has won with \(currentTeam2Pts) points!", message: nil, preferredStyle: .alert)
        winningAlert.addAction(UIAlertAction(title: "Continue", style: .default, handler: nil))
        self.present(winningAlert, animated: true)
    }
    
    

}
