//
//  UserDefaultsHandler.swift
//  Domino-CSE438FinalProject
//
//  Created by Jeanette Rovira on 7/26/21.
//

import Foundation
import UIKit

class UserDefaultsHandler {

    enum Destinations: String {
        case playerNames = "playerNames"
        case team1Score = "team1Score"
        case team2Score = "team2Score"
    }
        
    func encode(data: Any, whereTo: Destinations) {
        switch whereTo {
            case .playerNames:
                guard let playerNames = data as? [String] else { return } // Check if data can be cast as a [String]
                
                if let encoded = try? JSONEncoder().encode(playerNames) { // Encode Data
                    UserDefaults.standard.set(encoded, forKey: whereTo.rawValue)
                }
            case .team1Score:
                guard let score = data as? Int else { return } // Check if data can be cast as an Int
                
                if let encoded = try? JSONEncoder().encode(score) { // Encode Data
                    UserDefaults.standard.set(encoded, forKey: whereTo.rawValue)
                }
            case .team2Score:
                guard let score = data as? Int else { return } // Check if data can be cast as an Int
                
                if let encoded = try? JSONEncoder().encode(score) { // Encode Data
                    UserDefaults.standard.set(encoded, forKey: whereTo.rawValue)
                }
            }
    }
        
    func decode(fromWhere: Destinations) -> Any {
            switch fromWhere {
            case .team1Score:
                if let data = UserDefaults.standard.data(forKey: fromWhere.rawValue) {
                    if let decoded = try? JSONDecoder().decode(Int.self, from: data) {
                        return decoded
                    }
                }
            case .team2Score:
                if let data = UserDefaults.standard.data(forKey: fromWhere.rawValue) {
                    if let decoded = try? JSONDecoder().decode(Int.self, from: data) {
                        return decoded
                    }
                }
            case .playerNames:
                if let data = UserDefaults.standard.data(forKey: fromWhere.rawValue) {
                    if let decoded = try? JSONDecoder().decode([String].self, from: data) {
                        return decoded
                    }
                }
            }
            return "ERROR"
    }
    
    
}
