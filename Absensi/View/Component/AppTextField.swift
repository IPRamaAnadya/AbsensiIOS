//
//  AppTextField.swift
//  Absensi
//
//  Created by I putu Rama anadya on 14/09/23.
//

import SwiftUI

struct AppTextField: View {
    
    @Binding var username: String
    
    let iconName: String
    let hint: String
    
    init(username: Binding<String>, iconName: String, hint: String = "") {
        self._username = username
        self.iconName = iconName
        self.hint = hint
    }
    
    var body: some View {
        HStack {
            Spacer(minLength: 20)
            HStack(alignment: .center, spacing: 10) {
                Image(systemName: iconName)
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Color.gray)
                    .frame(width: 20, height: 20, alignment: .top)
                    .foregroundColor(.black)
                
                    .frame(minWidth: 0, maxWidth: 40)
                TextField (hint, text: $username)
                    .frame(height: 45)
            }
            .padding([.top,.bottom], 2)
            .padding(.leading, 5)
            .background(Color.white, alignment: .center)
            .cornerRadius(10)
            
            Spacer(minLength: 20)
        }
        .shadow(color: Color.gray.opacity(0.1), radius: 20, x: -1, y: 10)
    }
}

struct AppTextField_Previews: PreviewProvider {
    static var previews: some View {
        @State var test = ""
        AppTextField(username: $test, iconName: "people")
    }
}
