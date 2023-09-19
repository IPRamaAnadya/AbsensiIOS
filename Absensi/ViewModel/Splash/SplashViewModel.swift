//
//  SplashViewModel.swift
//  Absensi
//
//  Created by I putu Rama anadya on 19/09/23.
//

import SwiftUI


class SplashViewModel: ObservableObject {
    
    @Published var goToLogin = false
    @Published var goToDashboard = false
    
    func getNextPage() {
        
        guard let username = UserSettings.shared.getUsername(),
              let password = UserSettings.shared.getPassword()
        else {
            goToLogin = true
            return
        }
        
        print(username)
        print(password)
        NetworkRepository.shared.login(username: username, password: password) { result in
            if result == true {
                print("Go to Dashboard")
                self.goToDashboard = true
            } else {
                print("Go to Login")
                self.goToLogin = true
            }
        }
        
    }
    
}
