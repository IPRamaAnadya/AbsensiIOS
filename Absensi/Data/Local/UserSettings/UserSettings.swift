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
    private let authkey = "authKey"
    
    func setAuthToken(token: String) {
        UserDefaults.standard.set(token, forKey: authkey)
    }
    
    func getAuthToken() -> String? {
        return UserDefaults.standard.object(forKey: authkey) as? String
    }
}
