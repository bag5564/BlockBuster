//
//  HighScoreRowView.swift
//  BlockBuster
//
//  Created by Ben Gutierrez on 11/19/21.
//

import SwiftUI

struct HighScoreRowView: View {
    var highscore : HighScore
    var body: some View {
        HStack{
            Text(highscore.name)
                .bold()
            Spacer()
            Text("\(highscore.score)")
                .bold()
        }
        .padding()
        
    }
}

struct HighScoreRowView_Previews: PreviewProvider {
    static var previews: some View {
        HighScoreRowView(highscore: HighScore.standard)
    }
}
