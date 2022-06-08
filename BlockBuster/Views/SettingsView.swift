//
//  SettingsView.swift
//  BlockBuster
//
//  Created by Ben Gutierrez on 11/9/21.
//

import SwiftUI

struct SettingsView: View {
    @Binding var settings : Settings
    @Binding var showSettings: Bool
    
    var body: some View {
        NavigationView {
            Form{
                Section(){
                    Text("Classic Mode").font(.largeTitle)
                }
                Section(header: Text("Difficulty")){
                    Picker("difficulty", selection: $settings.c_difficulty){
                        ForEach (Settings.Difficulty.allCases) {
                            Text($0.rawValue.capitalized).tag($0)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    Text("changes number of blocks and colors")
                        .font(.system(size: 12))
                }
                Section(){
                    Text("Survival Mode").font(.largeTitle)
                }
                Section(header: Text("Difficulty")){
                    Picker("difficulty", selection: $settings.s_difficulty){
                        ForEach (Settings.Difficulty.allCases) {
                            Text($0.rawValue.capitalized).tag($0)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    Text("changes speed of falling blocks")
                        .font(.system(size: 12))
                }
                Section(){
                    HStack{
                        Spacer()
                        Button(action: {self.showSettings.toggle()}, label: {Text("Done")})
                        Spacer()
                    }
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(settings: .constant(Settings.standard), showSettings: .constant(true))
    }
}
