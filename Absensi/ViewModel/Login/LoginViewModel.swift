//
//  LoginViewModel.swift
//  Absensi
//
//  Created by I putu Rama anadya on 19/09/23.
//

import SwiftUI

class LoginViewModel: ObservableObject {
    
    @Published var isLogin = false
    @Published var goCreatePassword = false
    @Published var goRegisterFace = false
    @Published var username = ""
    @Published var password = ""
    @Published var showLoading = false
    @Published var showAlert = false
    
    @Published var loginResponse: LoginResponse?
    
    
    init() {
//        UserSettings.shared.reset()
    }
    
    func login() {
        
        Helpers.shared.analyticsLog(itemID: "Login", itemName: "Menekan tombol login", contentType: .button)
        showLoading = true
        
        NetworkRepository.shared.login(username: username, password: password) { result in
            
            
            switch result {
            case .success(let model):
                UserSettings.shared.setCredential(username: self.username, password: self.password)
                self.showLoading = false
                
                guard let model = model else {
                    print("Data login kosong")
                    return
                }
                
                Helpers.shared.analyticsLog(itemID: "Login", itemName: "Berhasil login", contentType: .automatic)
                
                self.loginResponse = model
                
                if model.credential?.user?.telahUbahPassword == false {
                    Helpers.shared.analyticsLog(itemID: "Login", itemName: "Menuju halaman ubah password", contentType: .automatic)
                    self.goCreatePassword.toggle()
                    return
                }
                
                if model.credential?.user?.telahDaftarWajah == false {
                    Helpers.shared.analyticsLog(itemID: "Login", itemName: "Menuju halaman registrasi wajah", contentType: .automatic)
                    self.goRegisterFace.toggle()
                    return
                }
                Helpers.shared.analyticsLog(itemID: "Login", itemName: "Menuju halaman dashboard", contentType: .automatic)
                self.isLogin.toggle()
                
            case .failure(_):
                Helpers.shared.analyticsLog(itemID: "Login", itemName: "Gagal login", contentType: .automatic)
                self.showLoading = false
                self.showAlert = true
            }
            
        }
    }
    
    func dismissAlert() {
        showAlert = false
    }
}


