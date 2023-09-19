//
//  LoginViewModel.swift
//  Absensi
//
//  Created by I putu Rama anadya on 19/09/23.
//

import SwiftUI

class LoginViewModel: ObservableObject {
    
    @Published var isLogin = false
    @Published var username = ""
    @Published var password = ""
    @Published var showLoading = false
    @Published var showAlert = false
    
    
    init() {
//        UserSettings.shared.reset()
    }
    
    func login() {
        showLoading = true
        
        NetworkRepository.shared.login(username: username, password: password) { status in
            
            
            UserSettings.shared.setCredential(username: self.username, password: self.password)
            
            self.showLoading = false
            self.showAlert = !status
            self.isLogin = status
            
        }
    }
    
    func dismissAlert() {
        showAlert = false
    }
}


