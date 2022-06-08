//
//  PlayButtonView.swift
//  BlockBuster
//
//  Created by Ben Gutierrez on 11/9/21.
//

import SwiftUI

struct PlayButtonView: View {
    var label : String
    var symbol: String
    var body: some View {
        HStack{
            Image(systemName: symbol)
                .font(.system(size: 25))
            Text(label)
                .font(.system(size: 25, weight: .bold, design: .rounded))
                
        }
    }
}

struct PlayButtonView_Previews: PreviewProvider {
    static var previews: some View {
        PlayButtonView(label: "Play Classic Mode", symbol: "play.circle.fill")
    }
}
