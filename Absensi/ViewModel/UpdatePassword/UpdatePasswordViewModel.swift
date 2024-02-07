//
//  UpdatePasswordViewModel.swift
//  Absensi
//
//  Created by I putu Rama anadya on 29/09/23.
//

import Foundation

class UpdatePasswordViewModel: ObservableObject {
    
    @Published var currentPassword: String = ""
    @Published var newPassword: String = ""
    @Published var confirmPassword: String = ""
    
    @Published var loading: Bool = false
    
    @Published var showMessage: Bool = false
    @Published var message: String = ""
    
    @Published var showSuccessMessage: Bool = false
    
    @MainActor
    func changePassword() {
        
        Helpers.shared.analyticsLog(itemID: "UpdatePassword", itemName: "menekan tombol konfirmasi", contentType: .button)
        
        guard self.validate() else {
            return
        }
        
        loading = true
        NetworkRepository.shared.changePassword(from: currentPassword, to: newPassword, confirm: confirmPassword) { result in
            switch result {
            case .success(_):
                UserSettings.shared.setCredential(username: UserSettings.shared.getUsername() ?? "", password: self.newPassword)
                self.showSuccessMessage.toggle()
                Helpers.shared.analyticsLog(itemID: "UpdatePassword", itemName: "berhasil update password", contentType: .automatic)
                self.loading = false
            case .failure(_):
                Helpers.shared.analyticsLog(itemID: "UpdatePassword", itemName: "gagal update password", contentType: .automatic)
                print("gagal")
                self.message = "Pastikan password yang anda input benar"
                self.showMessage.toggle()
                self.loading = false
            }
        }
    }
    
    func clear() {
        currentPassword = ""
        newPassword = ""
        confirmPassword = ""
        loading = false
        showMessage = false
        showSuccessMessage = false
        message = ""
    }
    
    private func validate() -> Bool {
        // check password is not empty or not 8 character
        guard
            currentPassword != "", currentPassword.count > 7,
            newPassword != "", newPassword.count > 7,
            confirmPassword != "", confirmPassword.count > 7
        else {
            message = "Password harus lebih dari atau sama dengan 8"
            showMessage.toggle()
            return false
        }
        
        // matching password
        if newPassword != confirmPassword {
            message = "konfirmasi password harus sama"
            showMessage.toggle()
            return false
        }
        return true
    }
    
}
