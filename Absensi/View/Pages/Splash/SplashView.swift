//
//  SplashView.swift
//  Absensi
//
//  Created by I putu Rama anadya on 14/09/23.
//

import SwiftUI

struct SplashView: View {
    
    @State private var isFinish = false
    
    var body: some View {
        ZStack {
            if !isFinish {
                VStack {
                    Spacer()
                    Image("app_logo")
                    Spacer()
                    Text("Develop by Maiharta")
                        .font(.caption2)
                        .foregroundColor(.white)
                        .padding()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    Color("primary")
                )
            } else {
                LoginView()
                    .transition(.move(edge: .bottom))
                    .animation(.spring())
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                isFinish = true
            }
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
