//
//  ClassicView.swift
//  BlockBuster
//
//  Created by Ben Gutierrez on 11/8/21.
//

import SwiftUI

struct ClassicView: View {
    @EnvironmentObject var manager: BlockBusterManager
    @Environment(\.dismiss) var dismiss
    
    @State private var username: String = ""
    
    var body: some View {
       VStack{
           //To add color to NavigationView area
           Rectangle()
               .frame(height: 0)
               .background(Color.yellow)
           ZStack{
                VStack(spacing:0) {
                    ForEach(0 ..< manager.blocks.count){row in
                        RowView(row: row, count: manager.blocks[row].count)
                    }
                }
                VStack{
                    Rectangle()
                        .fill(Color.yellow)
                        .frame(height: 50)
                        .overlay(Text("Score: \(manager.score)").font(.system(size: 20, weight: .bold, design: .rounded)))
                }
                .frame(maxHeight: .infinity , alignment: .bottom)
               AddScoreView(username: $username)
           }
            
        }
        .navigationTitle("Classic Mode - " + manager.settings.c_difficulty.rawValue.capitalized)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing){
                Button(action: {dismiss()}){
                    Image(systemName: "homekit")
                    
                }
            }
        }
    }
}

struct ClassicView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ClassicView().environmentObject(BlockBusterManager())
        }
    }
}
