//
//  AppButton.swift
//  Absensi
//
//  Created by I putu Rama anadya on 14/09/23.
//

import SwiftUI

struct AppButton: View {
    
    let title: String
    let action: () -> Void
    @Binding var showLoading: Bool
    
    init(title: String, showLoading: Binding<Bool>, action: @escaping () -> Void) {
        self.title = title
        self._showLoading = showLoading
        self.action = action
    }
    
    var body: some View {
        HStack {
            Spacer(minLength: 20)
            Button(
                action: action,
                label: {
                    HStack(spacing: 10) {
                        if(showLoading) {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        }
                        Text(title)
                            .font(.callout)
                            .fontWeight(.bold)
                        .shadow(color: Color.red.opacity(0.35), radius: 20, x: -1, y: 10)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding([.bottom, .top], 12)
                    .background(Color("primary"))
                    .cornerRadius(10)
                    
                }
            )
            Spacer(minLength: 20)
        }
    }
}

struct AppButton_Previews: PreviewProvider {
    static var previews: some View {
        @State var showLoading = true
        AppButton(title: "Test",showLoading: $showLoading, action: {})
    }
}
