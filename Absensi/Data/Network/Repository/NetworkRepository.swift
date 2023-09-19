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
                    print("Login Success")
                    guard let jsonData = data as? Data else {
                        print("json is not Data")
                        return
                    }
                    let loginData = Helpers.shared.ParsingJsonToModel(LoginResponse.self, from: jsonData)
                    UserSettings.shared.setIdentities(name: loginData?.credential?.user?.name ?? "", role: loginData?.credential?.user?.skpd ?? "", profile: loginData?.credential?.user?.wajahURL ?? "", position: loginData?.credential?.user?.jabatan ?? "")
                    
                case .failure(_):
                    completion(false)
                    print("Login Failed")
                }
            }
    }
}
