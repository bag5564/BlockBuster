//
//  ShowScoreView.swift
//  BlockBuster
//
//  Created by Ben Gutierrez on 11/20/21.
//

import SwiftUI

struct ShowScoreView: View {
    @EnvironmentObject var manager: BlockBusterManager
    var mode : String
    var difficulty = ["Easy", "Medium", "Hard"]
    @State private var selectedDifficulty = "Easy"
    
    var body: some View {
        List{
            Picker("difficulty", selection: $selectedDifficulty){
                ForEach (difficulty, id:\.self) {
                    Text($0).tag($0)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            
            HStack{
                Text("Name")
                    .bold()
                Spacer()
                Text("Score")
                    .bold()
            }
            .font(.system(size: 25))
            let scoreIndex = manager.findTopTenScores(gameMode: mode, difficulty: selectedDifficulty)
            if (scoreIndex.isEmpty){
                Text("No scores recorded")
            }
            else {
                ForEach(scoreIndex, id:\.self){i in
                    HighScoreRowView(highscore: manager.highScoreModel.highscores[i])
                }
            }
        }
        .navigationTitle("High Scores")
    }
}

struct ShowScoreView_Previews: PreviewProvider {
    static var previews: some View {
        ShowScoreView(mode: "Classic").environmentObject(BlockBusterManager())
    }
}
