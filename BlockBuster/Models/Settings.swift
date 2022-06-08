//
//  Settings.swift
//  BlockBuster
//
//  Created by Ben Gutierrez on 11/9/21.
//

import Foundation

struct Settings {
    var c_difficulty : Difficulty
    var s_difficulty : Difficulty
    enum Difficulty: String, CaseIterable, Identifiable {
        var id: String {self.rawValue }
        case easy, medium, hard
    }
    // for Classic mode
    var num_blocks : Int {
        if c_difficulty == .easy {
            return 6
        }
        else if c_difficulty == .medium {
            return 8
        }
        else {
            return 10
        }
    }
    var colorRange : ClosedRange <Int> {
        if c_difficulty == .easy {
            return 1...4
        }
        else if c_difficulty == .medium {
            return 1...5
        }
        else {
            return 1...6
        }
    }
    // for Survival mode
    var speed : Double {
        if s_difficulty == .easy {
            return 1.0
        }
        else if s_difficulty == .medium {
            return 0.8
        }
        else {
            return 0.6
        }
    }
    let n_rows = 10
    let n_cols = 6
    let colorRangeSurv = 1...5
    let levels = 3
    let maxTime = 30
    
    
    static let standard = Settings(c_difficulty: .easy, s_difficulty: .easy)
}

enum GameMode: String, CaseIterable, Identifiable {
    var id: String {self.rawValue }
    case classic, survival
}
