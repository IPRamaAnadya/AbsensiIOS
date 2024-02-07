//
//  GuestRegisterView.swift
//  Absensi
//
//  Created by I putu Rama anadya on 17/11/23.
//

import SwiftUI

struct GuestRegisterView: View {
    
    @ObservedObject var vm = GuestRegisterViewModel()
    
    @State private var showPrivacyPolice = false
    @State private var agree = false
    
    var body: some View {
        ScrollView {
            VStack {
                Text("Nama")
                    .fontWeight(.bold)
                    .padding(.horizontal, 20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 36)
                AppTextField(username: $vm.name, iconName: "person", hint: "Masukkan nama Anda...")
                Text("Username")
                    .fontWeight(.bold)
                    .padding(.horizontal, 20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 10)
                AppTextField(username: $vm.username, iconName: "person.text.rectangle", hint: "Masukkan Username...")
                Text("Password")
                    .fontWeight(.bold)
                    .padding(.horizontal, 20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 10)
                AppSecureField(text: $vm.password, iconName: "lock", hint: "****")
                Text("Konfirmasi Password")
                    .fontWeight(.bold)
                    .padding(.horizontal, 20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 10)
                AppSecureField(text: $vm.password_confirmation, iconName: "lock", hint: "****")
                AppButton(title: "Daftar",showLoading: $vm.showLoading, action: {
                    if !agree {
                        showPrivacyPolice.toggle()
                        return
                    }
                    vm.createAccount()
                })
                    .padding(.top, 50)
            }
        }
        .navigationTitle("Daftar Akun")
        .onAppear {
            Helpers.shared.analyticsLog(itemID: "GuestRegister", itemName: "Berada di halaman Daftar akun", contentType: .button)
        }
        .navigationDestination(isPresented: $vm.registerFace, destination: {
            FaceRegisterView()
                .navigationBarHidden(true)
        })
        .alert(isPresented: $vm.showAlert, content: {
            Alert(
                title: Text(vm.title),
                message: Text(vm.message),
                dismissButton: .destructive(Text("OK"), action: {
                    if vm.title == "Berhasil" {
                        Helpers.shared.analyticsLog(itemID: "GuestRegister", itemName: "Berhasil membuat akun", contentType: .button)
                        vm.registerFace.toggle()
                        return
                    }
                    
                })
            )
        })
        .sheet(isPresented: $showPrivacyPolice, content: {
            PrivacyPoliceView(agree: $agree, showPrivacyPolice: $showPrivacyPolice)
                .onAppear {
                    print("APPEAR")
                }
                .onDisappear {
                    if agree {
                        vm.createAccount()
                    }
                }
        })
    }
}

#Preview {
    NavigationStack {
        GuestRegisterView()
    }
}
