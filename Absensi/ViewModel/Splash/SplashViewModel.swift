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
    @Published var goToCreatePassword = false
    @Published var goToFaceRegister = false
    @Published var faceRegisterState = false
    
    func getNextPage() {
        
        guard let username = UserSettings.shared.getUsername(),
              let password = UserSettings.shared.getPassword()
        else {
            goToLogin = true
            return
        }
        
        NetworkRepository.shared.login(username: username, password: password) { result in
            switch result {
            case .success(let model):
                guard let model = model else {
                    print("Data login kosong")
                    self.goToLogin = true
                    return
                }
                
                self.faceRegisterState = model.credential?.user?.telahDaftarWajah ?? true
                
                if model.credential?.user?.telahUbahPassword == false {
                    self.goToCreatePassword = true
                    Helpers.shared.analyticsLog(itemID: "Splash", itemName: "Menuju halaman membuat password", contentType: .automatic)
                    return
                }
                
                if model.credential?.user?.telahDaftarWajah == false {
                    Helpers.shared.analyticsLog(itemID: "Splash", itemName: "Menuju halaman register wajah", contentType: .automatic)
                    self.goToFaceRegister = true
                    return
                }
                
                Helpers.shared.analyticsLog(itemID: "Splash", itemName: "Menuju halaman dashboard", contentType: .automatic)
                self.goToDashboard = true
                
            case .failure(_):
                Helpers.shared.analyticsLog(itemID: "Splash", itemName: "Menuju halaman login", contentType: .automatic)
                self.goToLogin = true
            }
        }
        
    }
    
}
