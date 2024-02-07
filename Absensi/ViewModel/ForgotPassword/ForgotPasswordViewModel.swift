//
//  ForgotPasswordViewModel.swift
//  Absensi
//
//  Created by I putu Rama anadya on 05/10/23.
//

import SwiftUI

class ForgotPasswordViewModel: ObservableObject {
    
    @Published var loading = false
    @Published var nip = ""
    @Published var name = ""
    @Published var showAlert = false
    @Published var title = ""
    @Published var message = ""
    @Published var forgotPassword: ForgotPasswordResponse?
    
    enum AlertStatus {
        case success
        case failed
    }
    
    func dispose() {
        loading = false
        nip = ""
        name = ""
        showAlert = false
        title = ""
        message = ""
        forgotPassword = nil
    }
    
    func requestLink() {
        if loading {
            Helpers.shared.analyticsLog(itemID: "ForgotPassword", itemName: "Menekan tombol saat proses sedang berjalan", contentType: .button)
            showMessage(message: "Proses sedang berjalan", status: .failed)
            return
        }
        
        if nip.isEmpty, name.isEmpty {
            Helpers.shared.analyticsLog(itemID: "ForgotPassword", itemName: "Menekan tombol saat field belum diisi", contentType: .button)
            showMessage(message: "Pastikan mengisi data dengan benar", status: .failed)
            return
        }
        
        loading = true
        
        NetworkRepository.shared.forgotPassword(name: name, nip: nip) { result in
            switch result {
            case .success(let model):
                guard let model = model else {
                    self.showMessage(message: "Data tidak ditemukan", status: .failed)
                    return
                }
                self.showMessage(message: "Silahkan klik lanjutkan", status: .success)
                Helpers.shared.analyticsLog(itemID: "ForgotPassword", itemName: "Berhasil konfirmasi data", contentType: .automatic)
                withAnimation(.spring()) {
                    self.forgotPassword = model
                }
                self.loading = false
            case .failure(_):
                Helpers.shared.analyticsLog(itemID: "ForgotPassword", itemName: "Gagal konfirmasi data", contentType: .automatic)
                self.showMessage(message: "Request Gagal", status: .failed)
                self.loading = false
            }
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
