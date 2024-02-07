//
//  SplashView.swift
//  Absensi
//
//  Created by I putu Rama anadya on 14/09/23.
//

import SwiftUI

struct SplashView: View {
    
    @ObservedObject private var viewModel = SplashViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                Image("app_logo")
                Spacer()
                Text("Powered by Maiharta")
                    .font(.caption2)
                    .foregroundColor(.white)
                    .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Color("primary")
            )
        }
        .onAppear {
            Helpers.shared.analyticsLog(itemID: "Splash", itemName: "Aplikasi baru saja dibuka", contentType: .automatic)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                viewModel.getNextPage()
            }
        }
        .navigationDestination(isPresented: $viewModel.goToDashboard, destination: {
            DashboardView()
                .navigationBarHidden(true)
        })
        .navigationDestination(isPresented: $viewModel.goToLogin, destination: {
            LoginView()
                .navigationBarHidden(true)
        })
        .navigationDestination(isPresented: $viewModel.goToCreatePassword) {
            CreatePasswordView(faceRegisterState: viewModel.faceRegisterState)
                .navigationBarHidden(true)
        }
        .navigationDestination(isPresented: $viewModel.goToFaceRegister) {
            FaceRegisterView()
                .navigationBarHidden(true)
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
