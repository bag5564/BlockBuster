//
//  AddScoreView.swift
//  BlockBuster
//
//  Created by Ben Gutierrez on 11/15/21.
//

import SwiftUI

struct AddScoreView: View {
    @EnvironmentObject var manager: BlockBusterManager
    @Environment(\.dismiss) var dismiss
    let screenSize = UIScreen.main.bounds
    
    @Binding var username: String
    
    var body: some View {
        VStack{
            Text("Game Over")
                .font(.system(size: 35, weight: .bold, design: .rounded))
                .foregroundColor(.red)
                .padding(.bottom)
            Text("Save your score")
            TextField("your name", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Spacer()
            HStack {
                Button("Skip"){
                    manager.gameOver = false
                    dismiss()
                }
                Spacer()
                Button("Save"){
                    manager.gameOver = false
                    manager.saveScore(username: self.username)
                    manager.highScoreModel.save()
                    dismiss()
                }
            }
        }
        .padding()
        .frame(width: (screenSize.width * 0.85), height: (screenSize.height * 0.30))
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20.0, style: .continuous))
        .shadow(color: Color.gray, radius: 6, x: -7, y: -7)
        .offset(manager.gameOver ? CGSize(width: 0, height: 0) : CGSize(width: 0, height: screenSize.height) )
        .animation(.spring() , value: manager.gameOver)
    }
}

struct AddScoreView_Previews: PreviewProvider {
    static var previews: some View {
        AddScoreView(username: .constant("hinata"))
            .environmentObject(BlockBusterManager())
    }
}
