//
//  RowView.swift
//  BlockBuster
//
//  Created by Ben Gutierrez on 11/8/21.
//

import SwiftUI

struct RowView: View {
    @EnvironmentObject var manager: BlockBusterManager
    var row : Int
    var count : Int
    
    var body: some View {
        HStack(spacing:0){
            ForEach(0 ..< count) { col in
                if(manager.blocks[row][col].deleted){
                    Rectangle()
                        .frame(width: CGFloat(manager.blocks[row][col].size), height: CGFloat(manager.blocks[row][col].size))
                        .opacity(0)
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

struct RowView_Previews: PreviewProvider {
    static var previews: some View {
        RowView(row: 0, count: 0).environmentObject(BlockBusterManager())
    }
}
