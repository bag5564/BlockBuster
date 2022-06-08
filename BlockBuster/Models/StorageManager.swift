//
//  StorageManager.swift
//  BlockBuster
//
//  Created by Ben Gutierrez on 11/18/21.
//

import Foundation

class StorageManager{
    var highScores : [HighScore]
    let filename = "HighScore"
    let fileInfo : FileInfo
    
    init() {
        fileInfo = FileInfo(for: filename)
        // get data from fileInfo if it exists
        if fileInfo.exists {
            let decoder = JSONDecoder()
            do {
                let data = try Data(contentsOf: fileInfo.url)
                highScores = try decoder.decode([HighScore].self, from: data)
            } catch {
                print(error)
                highScores = []
            }
            return
        }
        
        highScores = []
    }
    
    func save(highscores:[HighScore]) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(highscores)
            try data.write(to: fileInfo.url)
        } catch {
            print(error)
        }
    }
}
