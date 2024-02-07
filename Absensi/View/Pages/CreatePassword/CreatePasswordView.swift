//
//  CreatePasswordView.swift
//  Absensi
//
//  Created by I putu Rama anadya on 15/09/23.
//

import SwiftUI

struct CreatePasswordView: View {
    
    @ObservedObject private var vm = CreatePasswordViewModel()
    
    init(faceRegisterState: Bool) {
        vm.goToFaceRegisterState = faceRegisterState
    }
    
    var body: some View {
        ScrollView {
            VStack {
                AppSecureField(text: $vm.newPassword, iconName: "lock", hint: "Masukkan kata sandi Anda...")
                    .padding(.top, 40)
                AppSecureField(text: $vm.confirmPassword, iconName: "lock", hint: "Konfirmasi kata sandi Anda...")
                AppButton(title: "Konfirmasi",showLoading: $vm.loading, action: {vm.createPassword()})
                    .padding(.top, 50)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
        }
        .navigationTitle("Buat Kata Sandi")
        .alert(isPresented: $vm.showAlert, content: {
            Alert(
                title: Text(vm.title),
                message: Text(vm.message),
                dismissButton: .destructive(Text("OK"), action: {
                    if vm.title == "Berhasil" {
                        Helpers.shared.analyticsLog(itemID: "CreatePassword", itemName: "Berhasil membuat password", contentType: .button)
                        if !vm.goToFaceRegisterState {
                            Helpers.shared.analyticsLog(itemID: "CreatePassword", itemName: "Menuju halaman registrasi wajah", contentType: .button)
                            vm.goToFaceRegister.toggle()
                            return
                        }
                        Helpers.shared.analyticsLog(itemID: "CreatePassword", itemName: "Menuju halaman dashboard", contentType: .button)
                        vm.goToDashboard.toggle()
                        return
                    }
                    
                })
            )
        })
        .navigationDestination(isPresented: $vm.goToDashboard, destination: {
            DashboardView()
                .navigationBarHidden(true)
        })
        .navigationDestination(isPresented: $vm.goToFaceRegister, destination: {
            FaceRegisterView()
                .navigationBarHidden(true)
        })
        .onAppear {
            Helpers.shared.analyticsLog(itemID: "CreatePassword", itemName: "berada di halaman buat kata sandi", contentType: .automatic)
        }
        .onDisappear {
            Helpers.shared.analyticsLog(itemID: "CreatePassword", itemName: "keluar dari halaman buat kata sandi", contentType: .automatic)
        }
    }
}

struct CreatePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CreatePasswordView(faceRegisterState: true)
        }
    }
}
