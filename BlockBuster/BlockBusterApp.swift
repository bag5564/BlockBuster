//
//  BlockBusterApp.swift
//  BlockBuster
//
//  Created by Ben Gutierrez on 11/7/21.
//

import SwiftUI

@main
struct BlockBusterApp: App {
    @Environment(\.scenePhase) private var scenePhase
    
    @StateObject var manager = BlockBusterManager()
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(manager)
        }
        .onChange(of: scenePhase) {phase in
            switch phase {
            case .background:
                manager.highScoreModel.save()
            default:
                break
            }
            
        }
    }
}
