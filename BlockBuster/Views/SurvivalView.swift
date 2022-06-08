//
//  SurvivalView.swift
//  BlockBuster
//
//  Created by Ben Gutierrez on 11/10/21.
//

import SwiftUI

struct SurvivalView: View {
    @EnvironmentObject var manager: BlockBusterManager
    @Environment(\.dismiss) var dismiss
    
    @State private var username: String = ""

    let screenSize = UIScreen.main.bounds
    
    var body: some View {
        VStack (spacing:0){
            //To add color to NavigationView area
            Rectangle()
                .frame(height: 0)
                .background(Color.yellow)
            ZStack{
                VStack {
                    Rectangle()
                        .fill(Color.yellow)
                        .frame(height: 40)
                        .overlay(Text("Time left: \(manager.timeLabel)").font(.system(size: 20, weight: .bold, design: .rounded)))
                }.frame(maxHeight: .infinity , alignment: .top)
                VStack(spacing:0) {
                     ForEach(0 ..< manager.offset){row in
                         SurvivalRowView(row: row, count: manager.blocks[row].count)
                     }
                     Rectangle().fill(Color.cyan).frame(width: CGFloat(manager.blockSize * manager.tcols), height: 1)
                     ForEach(manager.offset ..< manager.blocks.count){row in
                         SurvivalRowView(row: row, count: manager.blocks[row].count)
                     }
                     Rectangle().fill(Color.black).frame(width: CGFloat(manager.blockSize * manager.tcols), height: 1)
                     
                 }
                VStack(spacing:0){
                     Rectangle()
                         .fill(Color.yellow)
                         .frame(height: 50)
                         .overlay(Text("Score: \(manager.score)").font(.system(size: 20, weight: .bold, design: .rounded)))
                }.padding(0.0)
                 .frame(maxHeight: .infinity , alignment: .bottom)
                LevelFinishedView()
                AddScoreView(username: $username)
            }
             
         }
         .navigationTitle("Survival Mode - " + manager.settings.s_difficulty.rawValue.capitalized)
         .navigationBarTitleDisplayMode(.inline)
         .navigationBarBackButtonHidden(true)
         .toolbar {
             ToolbarItem(placement: .navigationBarTrailing){
                 Button(action: {manager.dismissSurvivalGame(); dismiss()}){
                     Image(systemName: "homekit")
                     
                 }
             }
         }
    }
}

struct SurvivalView_Previews: PreviewProvider {
    static var previews: some View {
        SurvivalView().environmentObject(BlockBusterManager())
    }
}

struct LevelFinishedView: View {
    @EnvironmentObject var manager: BlockBusterManager
    let screenSize = UIScreen.main.bounds
    
    var body: some View {
        VStack{
            Text("\(manager.levelOverlInfo)")
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .foregroundColor(.red)
            Text("Level \(manager.currentLevel) Complete")
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .foregroundColor(.red)
                .padding(.bottom)
            Text("wait for next level ...")
                .font(.system(size: 20, weight: .bold, design: .rounded))
            
        }
        .padding()
        .frame(width: (screenSize.width * 0.90), height: (screenSize.height * 0.30))
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20.0, style: .continuous))
        .shadow(color: Color.gray, radius: 6, x: -7, y: -7)
        .opacity(manager.levelOver ? 1 : 0)
    }
}
