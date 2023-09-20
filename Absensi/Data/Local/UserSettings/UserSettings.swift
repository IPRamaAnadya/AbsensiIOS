//
//  UserSettings.swift
//  Absensi
//
//  Created by I putu Rama anadya on 19/09/23.
//

import UIKit

class UserSettings {
    
    static let shared = UserSettings()
    
    private init() {}
    
    // KEY
    private let auth_key = "auth_key"
    private let username_key = "username_key"
    private let password_key = "password_key"
    private let name_key = "name_key"
    private let role_key = "role_key"
    private let profile_key = "profile_key"
    private let position_key = "position_key"
    
    func setAuthToken(token: String) {
        UserDefaults.standard.set(token, forKey: auth_key)
        print("Token Autentikasi disimpan")
    }
    
    func getAuthToken() -> String? {
        guard let data = UserDefaults.standard.object(forKey: auth_key) as? String, data != "" else {
            print("Gagal mendapatkan token autentikasi")
            return nil
        }
        print("Mengambil token autentikasi")
        return data
    }
    
    func setCredential(username: String, password: String) {
        UserDefaults.standard.set(username, forKey: username_key)
        UserDefaults.standard.set(password, forKey: password_key)
    }
    
    func getUsername() -> String? {
        return UserDefaults.standard.object(forKey: username_key) as? String
    }
    
    func getPassword() -> String? {
        return UserDefaults.standard.object(forKey: password_key) as? String
    }
    
    func setIdentities(name: String, role: String, profile: String, position: String) {
        UserDefaults.standard.set(name, forKey: name_key)
        UserDefaults.standard.set(role, forKey: role_key)
        UserDefaults.standard.set(profile, forKey: profile_key)
        UserDefaults.standard.set(position, forKey: position_key)
        
        print("Save user identities")
    }
    
    func getName() -> String? {
        return UserDefaults.standard.object(forKey: name_key) as? String
    }
    
    func getRole() -> String? {
        return UserDefaults.standard.object(forKey: role_key) as? String
    }
    
    func getProfile() -> String? {
        return UserDefaults.standard.object(forKey: profile_key) as? String
    }
    
    func getPosition() -> String? {
        return UserDefaults.standard.object(forKey: position_key) as? String
    }
    
    func reset() {
        if let appDomain = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: appDomain)
        }
    }
}
