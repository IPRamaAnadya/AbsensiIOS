//
//  ForgotPasswordView.swift
//  Absensi
//
//  Created by I putu Rama anadya on 15/09/23.
//

import SwiftUI

struct ForgotPasswordView: View {
    
    @ObservedObject private var vm = ForgotPasswordViewModel()
    
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
                AppTextField(username: $vm.nip, iconName: "person.text.rectangle", hint: "Masukkan username Anda...", keyboardType: .numberPad)
                
                
                if vm.forgotPassword != nil {
                    Link(destination: URL(string: vm.forgotPassword?.forgotData?.url ?? "https://tabanankab.go.id/")!, label: {
                        Text("Lanjutkan")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 45)
                            .background(
                                RoundedRectangle(cornerRadius: 10.0)
                                    .fill(Color.green)
                            )
                            .padding()
                    })
                } else {
                    AppButton(title: "Konfirmasi",showLoading: $vm.loading, action: {
                        vm.requestLink()
                    })
                        .padding(.top, 50)
                }
            }
        }
        .navigationBarTitle("Lupa Kata Sandi")
        .alert(isPresented: $vm.showAlert, content: {
            Alert(title: Text(vm.title), message: Text(vm.message), dismissButton: .destructive(Text("OK"), action: {}))
        })
        .onAppear {
            Helpers.shared.analyticsLog(itemID: "ForgotPassword", itemName: "berada di halaman lupa kata sandi", contentType: .automatic)
        }
        .onDisappear {
            Helpers.shared.analyticsLog(itemID: "ForgotPassword", itemName: "Keluar dari halaman lupa kata sandi", contentType: .automatic)
            vm.dispose()
        }
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ForgotPasswordView()
        }
    }
}
