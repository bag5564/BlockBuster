//
//  Block.swift
//  BlockBuster
//
//  Created by Ben Gutierrez on 11/7/21.
//

import Foundation
import SwiftUI

struct Block : Identifiable {
    let size : Int
    let color : Color
    var row : Int
    var column : Int
    var toDelete : Bool
    var deleted : Bool
    var falling : Bool = false
    var sameColorNeighbors : [Neighbor]
    var id = UUID()
    
    func moveBy(step:Int)->Block {
        return Block(size: size, color: color, row: row + step, column: column, toDelete: toDelete, deleted: deleted, falling: falling, sameColorNeighbors: sameColorNeighbors)
    }
}

struct Neighbor {
    var row : Int
    var column : Int
}
