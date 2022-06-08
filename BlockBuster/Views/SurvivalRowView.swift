//
//  SurvivalRowView.swift
//  BlockBuster
//
//  Created by Ben Gutierrez on 12/5/21.
//

import SwiftUI

struct SurvivalRowView: View {
    @EnvironmentObject var manager: BlockBusterManager
    var row : Int
    var count : Int
    
    var body: some View {
        HStack(spacing:0){
            ForEach(0 ..< count) { col in
                if(manager.blocks[row][col].falling){
                    Rectangle()
                        .strokeBorder(Color.black, lineWidth: 1)
                        .frame(width: CGFloat(manager.blocks[row][col].size), height: CGFloat(manager.blocks[row][col].size))
                        .background(Rectangle().foregroundColor(manager.blocks[row][col].color))
                }
                else if(manager.blocks[row][col].deleted){
                    Rectangle()
                        .strokeBorder(Color.gray, lineWidth: 1)
                        .frame(width: CGFloat(manager.blocks[row][col].size), height: CGFloat(manager.blocks[row][col].size))
                        .background(Rectangle().foregroundColor(manager.blocks[row][col].color))
                }
                else {
                    Rectangle()
                        .strokeBorder(Color.black, lineWidth: 1)
                        .frame(width: CGFloat(manager.blocks[row][col].size), height: CGFloat(manager.blocks[row][col].size))
                        .background(Rectangle().foregroundColor(manager.blocks[row][col].color))
                        .onTapGesture(count:2) {
                            manager.deleteGroup(currentBlock: manager.blocks[row][col])
                        }
                }
            }
        }
    }
}

struct SurvivalRowView_Previews: PreviewProvider {
    static var previews: some View {
        SurvivalRowView(row: 0, count: 0).environmentObject(BlockBusterManager())
    }
}
