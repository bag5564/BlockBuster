//
//  HighScore+Decodable.swift
//  BlockBuster
//
//  Created by Ben Gutierrez on 11/18/21.
//

import Foundation

extension HighScore {
    enum CodingKeys: String, CodingKey {
        case score
        case name
        case difficulty
        case gameMode
        }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        score = try values.decode(Int.self, forKey: .score)
        name = try values.decode(String.self, forKey: .name)
        difficulty = try values.decode(String.self, forKey: .difficulty)
        gameMode = try values.decode(String.self, forKey: .gameMode)
        
    }
}
