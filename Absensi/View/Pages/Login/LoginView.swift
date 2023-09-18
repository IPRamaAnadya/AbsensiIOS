//
//  LoginView.swift
//  Absensi
//
//  Created by I putu Rama anadya on 14/09/23.
//

import SwiftUI

struct LoginView: View {
    
    @State var username = ""
    @State var password = ""
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 15){
                RoundedRectangle(cornerRadius: 25 )
                    .fill(Color("primary"))
                    .frame(height: UIScreen.main.bounds.height * 3.5 / 6)
                    .overlay {
                        ZStack(alignment: .bottom) {
                            Text("Hai,\nLogin Sekarang")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .topLeading)
                                .padding(.top, 75)
                                .padding(.leading, 25)
                            Image("login")
                                .frame(alignment: .bottom)
                                .offset(y: 2)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .clipped()
                    }
                Rectangle()
                    .fill(Color.clear)
                    .frame(height: 10)
                AppTextField(username: $username, iconName: "person", hint: "Masukkan NIP Anda...")
                AppSecureField(text: $password, iconName: "lock", hint: "Masukkan kata sandi Anda...")
                Rectangle()
                    .fill(Color.clear)
                    .frame(height: 10)
                
                NavigationLink(destination: {
                    DashboardView()
                        .navigationBarBackButtonHidden()
                }, label: {
                    AppNavLinkView(title: "Masuk")
                })
            }
            
            Rectangle()
                .fill(Color.clear)
                .frame(height: 10)
            
            NavigationLink(destination: {
                ForgotPasswordView()
            }, label: {
                Text("Lupa kata sandi?")
                    .foregroundColor(Color("primary"))
            })
        }
        .background(Color.gray.opacity(0.01))
        .edgesIgnoringSafeArea(.top)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}






