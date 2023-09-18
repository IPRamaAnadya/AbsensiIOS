//
//  AppNavlink.swift
//  Absensi
//
//  Created by I putu Rama anadya on 14/09/23.
//

import SwiftUI

struct AppNavLinkView: View {
    
    var title: String
    
    init(title: String) {
        self.title = title
    }
    
    var body: some View {
        HStack {
            Spacer(minLength: 20)
            Text(title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding([.bottom, .top], 12)
                .background(Color("primary"))
                .cornerRadius(10)
                .shadow(color: Color.red.opacity(0.35), radius: 20, x: -1, y: 10)
            Spacer(minLength: 20)
        }
    }
}


struct AppNavlink_Previews: PreviewProvider {
    static var previews: some View {
        AppNavLinkView(title: "Test")
    }
}
