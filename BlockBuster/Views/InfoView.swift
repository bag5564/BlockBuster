//
//  InfoView.swift
//  BlockBuster
//
//  Created by Ben Gutierrez on 11/10/21.
//

import SwiftUI

struct InfoView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("Classic Mode")
                    .foregroundColor(Color.red)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .padding(.top)
                Text("Double tap a group of same-colored blocks to remove them from the board. As blocks are removed from the board, they will shift to avoid gaps between them. Try to get rid of as many blocks from the board as possible to score the most points.")
                    .fixedSize(horizontal: false, vertical: true)
                    .padding()
                Text("Survival Mode")
                    .foregroundColor(Color.red)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .padding(.top)
                Text("Double tap a group of same-colored blocks to remove them from the board. Blocks will begin falling from the top and add themselves to the gameboard. Advance to the next level by running out of available moves, using up all the allotted time, or letting a falling block exceed the top blue line. With each level the time interval between falling blocks decreases. Try to get as many points as you can in the three levels.")
                    .fixedSize(horizontal: false, vertical: true)
                    .padding()
                Spacer()
            }
            .navigationTitle("How to Play")
            .toolbar{
                Button("Done"){
                    dismiss()
                }
            }
        }
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}
