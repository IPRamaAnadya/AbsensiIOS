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
    
    func login(
        username: String,
        password: String,
        completion: @escaping (_ loginState: Bool) -> Void)
    {
        
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
                    print("Login Berhasil")
                    guard let jsonData = data as? Data else {
                        print("response bukan Data")
                        return
                    }
                    let loginData = Helpers.shared.ParsingJsonToModel(LoginResponse.self, from: jsonData)
                    UserSettings.shared.setAuthToken(token: loginData?.credential?.accessToken ?? "")
                    UserSettings.shared.setIdentities(name: loginData?.credential?.user?.name ?? "", role: loginData?.credential?.user?.skpd ?? "", profile: loginData?.credential?.user?.wajahURL ?? "", position: loginData?.credential?.user?.jabatan ?? "")
                    
                case .failure(_):
                    completion(false)
                    print("Login Gagal")
                }
            }
    }
    
    func fetchNotification(
        page: Int,
        perpage: Int,
        completion: @escaping (_ result: AppResult<NotificationResponse?>) -> Void
    ) {
        
        let authToken = UserSettings.shared.getAuthToken() ?? ""
        
        let headers: [String: String] = [
            "Authorization": "Bearer \(authToken)"
        ]
        
        let params: [String: String] = [
            "per_page": perpage.description,
            "page": page.description
        ]
        
        ServerAccessor.shared.get(
            endpoint: Env.apiURL+Env.notificationPath,
            to: NotificationResponse.self,
            headers: headers,
            params: params
        ) { result in
            switch result {
            case .success(let data):
                print("Berhasil mendapatkan data notifikasi")
                completion(.success(data))
            case .failure(let failure):
                print("Gagal mendapatkan data notifikasi")
                print(failure)
                completion(.failure(failure))
            }
        }
    }
    
    func fetchEvent(
        page: Int,
        perpage: Int,
        completion: @escaping (_ result: AppResult<NotificationResponse?>) -> Void
    ) {
        let authToken = UserSettings.shared.getAuthToken() ?? ""
        let headers = [
            "Authorization": authToken
        ]
        
        let params = [
            "page": page.description,
            "per_page": perpage.description
        ]
        
        ServerAccessor.shared.get(endpoint: Env.apiURL + Env.eventPath,
                                  to: NotificationResponse.self,
                                  headers: headers,
                                  params: params
        ) { result in
            switch result {
            case .success(let data):
                print("Berhasil mendapatkan data acara")
                completion(.success(data))
            case .failure(let failure):
                print("Gagal mendapatkan data acara")
                print(failure)
                completion(.failure(failure))
            }
        }
    }
    
    func fetchHistory(
        page: Int,
        perpage: Int,
        completion: @escaping (_ result: AppResult<NotificationResponse?>) -> Void
    ) {
        let authToken = UserSettings.shared.getAuthToken() ?? ""
        let headers = [
            "Authorization": authToken
        ]
        
        let params = [
            "page": page.description,
            "per_page": perpage.description
        ]
        
        ServerAccessor.shared.get(endpoint: Env.apiURL + Env.historyPath,
                                  to: NotificationResponse.self,
                                  headers: headers,
                                  params: params
        ) { result in
            switch result {
            case .success(let data):
                print("Berhasil mendapatkan data riwayat absen")
                completion(.success(data))
            case .failure(let failure):
                print("Gagal mendapatkan data riwayat absen")
                print(failure)
                completion(.failure(failure))
            }
        }
    }
    
    
}

enum AppResult<Model: Codable> {
    case success(Model)
    case failure(Error)
}


