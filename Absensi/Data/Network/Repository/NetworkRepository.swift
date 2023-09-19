//
//  NetworkRepository.swift
//  Absensi
//
//  Created by I putu Rama anadya on 19/09/23.
//

import Foundation

class NetworkRepository {
    
    static let shared = NetworkRepository()
    
    private init() {}
    
    func login(username: String, password: String, completion: @escaping (_ loginState: Bool) -> Void){
        
        let formData = [
            "username": username,
            "password": password
        ]
        
        ServerAccessor.shared.post(
            endpoint: Env.apiURL+Env.loginPath,
            formData: formData) { result in
                switch result {
                case .success(let data):
                    completion(true)
                    print("Login Success \n\(data)")
                case .failure(_):
                    completion(false)
                    print("Login Failed")
                }
            }
    }
}
