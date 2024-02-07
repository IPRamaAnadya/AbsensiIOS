//
//  GuestRegisterViewModel.swift
//  Absensi
//
//  Created by I putu Rama anadya on 17/11/23.
//

import SwiftUI

class GuestRegisterViewModel: ObservableObject {
    
    @Published var name: String = ""
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var password_confirmation: String = ""
    
    @Published var showLoading: Bool = false
    @Published var registerFace: Bool = false
    @Published var showAlert: Bool = false
    
    @Published var title = ""
    @Published var message = ""
    
    enum AlertStatus {
        case success
        case failed
    }
    
    @MainActor
    func createAccount() {
        if name == "", username == "", password == "", password_confirmation == "" {
            showMessage(message: "Kolom tidak boleh kosong", status: .failed)
            return
        }
        
        if password.count < 8 {
            showMessage(message: "Password harus lebih dari 8 karakter", status: .failed)
            return
        }
        
        if password != password_confirmation {
            showMessage(message: "kata sandi tidak cocok", status: .failed)
            return
        }
        
        showLoading.toggle()
        NetworkRepository.shared.createAccount(
            name: name,
            username: username,
            password: password,
            password_confirmation: password_confirmation
        ) { result in
            
            switch result {
            case .success(_):
                self.showMessage(message: "Akun berhasil dibuat", status: .success)
            case .failure(_):
                self.showMessage(message: "Username sudah terdaftar", status: .failed)
            }
            
            self.showLoading.toggle()
        }
    }
    
    func showMessage(message: String, status: AlertStatus) {
        switch status {
        case .success:
            title = "Berhasil"
            self.message = message
        case .failed:
            title = "Gagal"
            self.message = message
        }
        showAlert.toggle()
    }
}
