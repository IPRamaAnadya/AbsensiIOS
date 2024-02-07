//
//  UpdatePasswordView.swift
//  Absensi
//
//  Created by I putu Rama anadya on 15/09/23.
//

import SwiftUI

struct UpdatePasswordView: View {
    
    @ObservedObject private var vm = UpdatePasswordViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack {
                Text("Kata sandi awal")
                    .fontWeight(.bold)
                    .padding(.horizontal, 20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 36)
                AppSecureField(text: $vm.currentPassword, iconName: "lock", hint: "Masukkan kata sandi awal Anda...")
                Text("Kata sandi Baru")
                    .fontWeight(.bold)
                    .padding(.horizontal, 20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 36)
                AppSecureField(text: $vm.newPassword, iconName: "lock", hint: "Masukkan kata sandi baru Anda...")
                AppSecureField(text: $vm.confirmPassword, iconName: "lock", hint: "Konfirmasi kata sandi baru Anda...")
                AppButton(title: "Konfirmasi", showLoading: $vm.loading, action: {
                    vm.changePassword()
                })
                .padding(.top, 50)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .alert(isPresented: $vm.showMessage, content: {
                Alert(
                    title: Text("Perhatian!"),
                    message: Text(vm.message),
                    dismissButton: .destructive(Text("OK"), action: {vm.showMessage.toggle()})
                )
            })
            .alert(isPresented: $vm.showSuccessMessage, content: {
                Alert(
                    title: Text("Berhasil!"),
                    message: Text("Kata sandi berhasil diubah"),
                    dismissButton: .cancel(Text("OK"), action: {
                        vm.showMessage.toggle()
                        dismiss()
                    })
                )
            })
            
        }
        .navigationTitle("Ubah Kata Sandi")
        .onAppear {
            Helpers.shared.analyticsLog(itemID: "UpdatePassword", itemName: "berada di halaman update password", contentType: .automatic)
        }
        .onDisappear {
            Helpers.shared.analyticsLog(itemID: "UpdatePassword", itemName: "keluar dari halaman update password", contentType: .automatic)
            vm.clear()
        }
    }
}

struct UpdatePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            UpdatePasswordView()
        }
    }
}
