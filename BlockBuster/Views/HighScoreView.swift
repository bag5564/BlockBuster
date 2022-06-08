//
//  HighScoreView.swift
//  BlockBuster
//
//  Created by Ben Gutierrez on 11/18/21.
//

import SwiftUI

struct HighScoreView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var manager: BlockBusterManager
    
    var body: some View {
        TabView{
            ShowScoreView(mode: "Classic")
            .tabItem{
                Image(systemName: "1.circle")
                Text("Classic")
            }
            
            ShowScoreView(mode: "Survival")
            .tabItem{
                Image(systemName: "2.circle")
                Text("Survival")
            }
        }
    }
}

struct HighScoreView_Previews: PreviewProvider {
    static var previews: some View {
        HighScoreView().environmentObject(BlockBusterManager())
    }
}
