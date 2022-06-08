//
//  HighScore.swift
//  BlockBuster
//
//  Created by Ben Gutierrez on 11/18/21.
//

import Foundation

struct HighScore : Identifiable, Decodable, Encodable {
    var id = UUID()
    let score : Int
    let name : String
    let difficulty : String
    let gameMode : String
    
    static let standard = HighScore(score: 400, name: "Ben", difficulty: "Easy", gameMode: "Classic")
    
}
