//
//  CreatePasswordViewModel.swift
//  Absensi
//
//  Created by I putu Rama anadya on 03/10/23.
//

import SwiftUI

class CreatePasswordViewModel: ObservableObject {
    
    @Published var newPassword = ""
    @Published var confirmPassword = ""
    @Published var showAlert = false
    @Published var title = ""
    @Published var message = ""
    @Published var loading = false

    @Published var goToFaceRegister = false
    @Published var goToFaceRegisterState = false
    
    @Published var goToDashboard = false
    
    @MainActor
    func createPassword() {
        Helpers.shared.analyticsLog(itemID: "CreatePassword", itemName: "Menekan tombol buat password", contentType: .button)
        if !validate() {
            return
        }
        
        loading = true
        
        let currentPassword = UserSettings.shared.getPassword() ?? ""
        
        NetworkRepository.shared.changePassword(from: currentPassword, to: newPassword, confirm: confirmPassword) { result in
            
            switch result {
            case .success(let model):
                guard let model = model else {
                    print("Data ubah password kosong")
                    self.errorMessage(message: "Server tidak meresponse")
                    return
                }
                UserSettings.shared.setCredential(username: UserSettings.shared.getUsername() ?? "", password: currentPassword)
                self.successMessage(message: "Berhasil membuat kata sandi")
                self.loading = false
            case .failure(_):
                self.errorMessage(message: "Terjadi kesalahan")
                self.loading = false
            }
            
        }
    }
    
    @MainActor
    func validate() -> Bool {
        
        if newPassword.isEmpty, confirmPassword.isEmpty {
            print("passowrd kosong")
            errorMessage(message: "Harap masukkan password dengan benar")
            return false
        }
        
        if newPassword.count < 8, confirmPassword.count < 8 {
            print("Password harus lebih dari 8 huruf")
            errorMessage(message: "Password harus lebih dari 8 huruf")
            return false
        }
        
        if newPassword != confirmPassword {
            print("Harap konfirmasi password dengan benar")
            errorMessage(message: "Harap konfirmasi password dengan benar")
            return false
        }
        
        return true
    }
    
    @MainActor
    func errorMessage(message: String) {
        title = "Gagal"
        self.message = message
        showAlert.toggle()
    }
    
    @MainActor
    func successMessage(message: String) {
        title = "Berhasil"
        self.message = message
        showAlert.toggle()
    }
}
