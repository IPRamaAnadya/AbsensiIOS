//
//  LoginView.swift
//  Absensi
//
//  Created by I putu Rama anadya on 14/09/23.
//

import SwiftUI

struct LoginView: View {
    
    @ObservedObject private var viewModel = LoginViewModel()
    
    
    @State private var showPrivacyPolice = false
    @State private var agree = false
    
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
                AppTextField(username: $viewModel.username, iconName: "person", hint: "Masukkan Username Anda...")
                AppSecureField(text: $viewModel.password, iconName: "lock", hint: "Masukkan kata sandi Anda...")
                NavigationLink(destination: {
                    ForgotPasswordView()
                }, label: {
                    Text("Lupa kata sandi?")
                        .foregroundColor(Color("primary"))
                })
                
                Rectangle()
                    .fill(Color.clear)
                    .frame(height: 10)
                
                AppButton(title: "Login",showLoading: $viewModel.showLoading, action: {
                    if !agree {
                        showPrivacyPolice.toggle()
                        return
                    }
                    viewModel.login()
                })
                
                NavigationLink(destination: {
                    GuestRegisterView()
                }, label: {
                    Text("Buat akun")
                        .foregroundColor(Color("primary"))
                })
                .navigationDestination(isPresented: $viewModel.isLogin) {
                    DashboardView()
                        .navigationBarHidden(true)
                }
                .navigationDestination(isPresented: $viewModel.goCreatePassword) {
                    CreatePasswordView(faceRegisterState: viewModel.loginResponse?.credential?.user?.telahDaftarWajah ?? true)
                        .navigationBarHidden(true)
                }
                .navigationDestination(isPresented: $viewModel.goRegisterFace) {
                    FaceRegisterView()
                        .navigationBarHidden(true)
                }

                .alert(isPresented: $viewModel.showAlert) {
                    Alert(
                        title: Text("Login Gagal"),
                        message: Text("Username atau password salah"),
                        dismissButton: .cancel(Text("OK"), action: {
                            viewModel.dismissAlert()
                        })
                    )
                }
                .sheet(isPresented: $showPrivacyPolice, content: {
                    PrivacyPoliceView(agree: $agree, showPrivacyPolice: $showPrivacyPolice)
                        .onAppear {
                            print("APPEAR")
                        }
                        .onDisappear {
                            if agree {
                                viewModel.login()
                            }
                        }
                })
            }
        }
        .background(Color.gray.opacity(0.01))
        .edgesIgnoringSafeArea(.top)
        .onAppear {
            Helpers.shared.analyticsLog(itemID: "Login", itemName: "berada di halaman login", contentType: .automatic)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}






