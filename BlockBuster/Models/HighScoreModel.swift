//
//  HighScoreModel.swift
//  BlockBuster
//
//  Created by Ben Gutierrez on 11/18/21.
//

import Foundation

struct HighScoreModel{
    let manager : StorageManager
    var highscores : [HighScore]
    
    init() {
        manager = StorageManager()
        highscores = manager.highScores
    }
    
    func save() {
        manager.save(highscores: highscores)
    }
    
    func topTenScores(){
        
    }
}
