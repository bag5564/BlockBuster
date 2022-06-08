//
//  HomeView.swift
//  BlockBuster
//
//  Created by Ben Gutierrez on 11/7/21.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var manager: BlockBusterManager
    @State private var isShowingClassic = false
    @State private var isShowingSurvival = false
    @State private var showSettings = false
    @State private var showInfo = false
    @State private var showScores = false
    
    let screenSize = UIScreen.main.bounds
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                // Logo
                LogoView()
                    .padding(.top)
                // Play buttons
                HStack{
                    Spacer()
                    VStack{
                        NavigationLink(destination: ClassicView(), isActive: $isShowingClassic){EmptyView()}
                        Button(action: {manager.initClassicGame(height: Int(screenSize.height), width: Int(screenSize.width)); self.isShowingClassic = true}) {
                            PlayButtonView(label: "Play Classic Mode", symbol: "play.circle.fill")
                        }
                        .modifier(PlayButtonModifier())
                   
                        NavigationLink(destination: SurvivalView(), isActive: $isShowingSurvival){EmptyView()}.padding(.top)
                        Button(action: {manager.initSurvivalGame(height: Int(screenSize.height), width: Int(screenSize.width)); self.isShowingSurvival = true}) {
                            PlayButtonView(label: "Play Survival Mode", symbol: "play.circle.fill")
                        }
                        .modifier(PlayButtonModifier())
                    }
                    Spacer()
                }
                .padding(.bottom)
                // Extras
                Button(action: {showSettings.toggle()}){
                    HStack {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
                }
                .modifier(OptionButtonModifier())
                
                Button(action: {showInfo.toggle()}){
                    HStack{
                        Image(systemName: "info.circle")
                        Text("How to Play")
                    }
                }
                .modifier(OptionButtonModifier())
                
                NavigationLink(destination: HighScoreView(), isActive: $showScores){EmptyView()}
                .padding(.top, 5)
                Button(action: {showScores = true}){
                    HStack{
                        Image(systemName: "star")
                        Text("High Scores")
                    }
                }
                .modifier(OptionButtonModifier())
                
                Spacer()
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .sheet(isPresented: $showSettings, content: {SettingsView(settings: $manager.settings, showSettings: $showSettings)})
        .sheet(isPresented: $showInfo , content: {InfoView()})
    }
}

struct LogoView: View {
    var body: some View {
        HStack{
            Spacer()
            VStack{
                Text("Block Buster")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundColor(.red)
                    .bold()
                    .padding(.bottom)
                Image(systemName: "squareshape.split.3x3")
                    .font(.system(size: 100))
            }
            Spacer()
        }
        .padding(.vertical)
    }
}

struct PlayButtonModifier : ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color.blue)
            .foregroundColor(Color.white)
            .cornerRadius(20)
    }
}
struct OptionButtonModifier : ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 25))
            .padding(.leading, 50)
            .padding(.bottom, 10)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(BlockBusterManager())
    }
}
