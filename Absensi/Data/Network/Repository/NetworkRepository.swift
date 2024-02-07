//
//  NetworkRepository.swift
//  Absensi
//
//  Created by I putu Rama anadya on 19/09/23.
//

import Foundation
import UIKit

class NetworkRepository {
    
    static let shared = NetworkRepository()
    
    private init() {}
    
    func login(
        username: String,
        password: String,
        completion: @escaping (_ result: AppResult<LoginResponse?>) -> Void)
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
                    guard let jsonData = data as? Data else {
                        print("response bukan Data")
                        return
                    }
                    let loginData = Helpers.shared.ParsingJsonToModel(LoginResponse.self, from: jsonData)
                    UserSettings.shared.setAuthToken(token: loginData?.credential?.accessToken ?? "")
                    UserSettings.shared.setIdentities(name: loginData?.credential?.user?.name ?? "", role: loginData?.credential?.user?.skpd ?? "", profile: loginData?.credential?.user?.wajahURL ?? "", position: loginData?.credential?.user?.jabatan ?? "")
                    completion(.success(loginData))
                case .failure(let failure):
                    completion(.failure(failure))
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
                completion(.success(data))
            case .failure(let failure):
                print(failure)
                completion(.failure(failure))
            }
        }
    }
    
    func fetchEvent(
        page: Int,
        perpage: Int,
        completion: @escaping (_ result: AppResult<AllEventsResponse?>) -> Void
    ) {
        let authToken = UserSettings.shared.getAuthToken() ?? ""
        let headers = [
            "Authorization": "Bearer \(authToken)"
        ]
        
        let params = [
            "page": page.description,
            "per_page": perpage.description
        ]
        
        ServerAccessor.shared.get(endpoint: Env.apiURL + Env.eventPath,
                                  to: AllEventsResponse.self,
                                  headers: headers,
                                  params: params
        ) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let failure):
                print(failure)
                completion(.failure(failure))
            }
        }
    }
    
    func fetchUpComingEvent(
        page: Int,
        perpage: Int,
        completion: @escaping (_ result: AppResult<AllEventsResponse?>) -> Void
    ) {
        let authToken = UserSettings.shared.getAuthToken() ?? ""
        let headers = [
            "Authorization": "Bearer \(authToken)"
        ]
        
        let calendar = Calendar.current
        let tommorow = calendar.date(byAdding: .day, value: 1, to: Date())
        let nextWeek = calendar.date(byAdding: .day, value: 7, to: Date())
        let tommorowMidnight = Int(calendar.startOfDay(for: tommorow!).timeIntervalSince1970)
        let nextWeekMidnight = Int(calendar.startOfDay(for: nextWeek!).timeIntervalSince1970)
        
        let params = [
            "page": page.description,
            "per_page": perpage.description,
            "start_date": tommorowMidnight.description,
            "end_date": nextWeekMidnight.description
        ]
        
        ServerAccessor.shared.get(endpoint: Env.apiURL + Env.eventPath,
                                  to: AllEventsResponse.self,
                                  headers: headers,
                                  params: params
        ) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let failure):
                print(failure)
                completion(.failure(failure))
            }
        }
    }
    
    func fetchSingleEvent(
        id: Int,
        completion: @escaping (_ result: AppResult<SingleEventResponse?>) -> Void
    ) {
        let authToken = UserSettings.shared.getAuthToken() ?? ""
        let headers = [
            "Authorization": "Bearer \(authToken)"
        ]
        
        let params = [
            "id": id.description,
        ]
        
        ServerAccessor.shared.get(endpoint: Env.apiURL + Env.eventPath,
                                  to: SingleEventResponse.self,
                                  headers: headers,
                                  params: params
        ) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let failure):
                print(failure)
                completion(.failure(failure))
            }
        }
    }
    
    func fetchHistory(
        page: Int,
        perpage: Int,
        completion: @escaping (_ result: AppResult<HistoriesResponse?>) -> Void
    ) {
        let authToken = UserSettings.shared.getAuthToken() ?? ""
        let headers = [
            "Authorization": "Bearer \(authToken)"
        ]
        
        let params = [
            "page": page.description,
            "per_page": perpage.description
        ]
        
        ServerAccessor.shared.get(endpoint: Env.apiURL + Env.historyPath,
                                  to: HistoriesResponse.self,
                                  headers: headers,
                                  params: params
        ) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let failure):
                print(failure)
                completion(.failure(failure))
            }
        }
    }
    
    func changePassword(
        from currentPassword: String,
        to newPassword: String,
        confirm confirmPassword: String,
        completion: @escaping (_ result: AppResult<ChangePasswordResponse?>) -> Void
    ) {
        let authToken = UserSettings.shared.getAuthToken() ?? ""
        let headers = [
            "Authorization": "Bearer \(authToken)"
        ]
        
        let formData = [
            "password_sekarang": currentPassword.description,
            "password": newPassword.description,
            "password_confirmation": confirmPassword.description
        ]
        
        ServerAccessor.shared.post(
            endpoint: Env.apiURL + Env.changePassword,
            headers: headers,
            formData: formData
        ) { result in
                switch result {
                case .success(let data):
                    guard let jsonData = data as? Data else {
                        print("response bukan Data")
                        return
                    }
                    let responseModel = Helpers.shared.ParsingJsonToModel(ChangePasswordResponse.self, from: jsonData)
                    completion(.success(responseModel))
                case .failure(let failure):
                    completion(.failure(failure))
                }
            }
    }
    
    func absentIn(
        image: UIImage,
        token: String,
        isDeletedToken: String,
        completion: @escaping (_ result: AppResult<AbsentInResponse?>) -> Void
    ) {
        let authToken = UserSettings.shared.getAuthToken() ?? ""
        let headers = [
            "Authorization": "Bearer \(authToken)"
        ]
        
        let formData: [String: Any] = [
            "image": image,
            "token": token,
            "delete_token": isDeletedToken
        ]
        
        ServerAccessor.shared.post(endpoint: Env.apiURL+Env.absentIN,
                                   headers: headers,
                                   formData: formData) { result in
            switch result {
            case .success(let data):
                guard let jsonData = data as? Data else {
                    print("response bukan Data")
                    return
                }
                let responseModel = Helpers.shared.ParsingJsonToModel(AbsentInResponse.self, from: jsonData)
                completion(.success(responseModel))
            case .failure(let failure):
                completion(.failure(failure))
            }
            
        }
    }
    
    func absentOUT(
        image: UIImage,
        token: String,
        isDeletedToken: String,
        completion: @escaping (_ result: AppResult<AbsentOutResponse?>) -> Void
    ) {
        let authToken = UserSettings.shared.getAuthToken() ?? ""
        let headers = [
            "Authorization": "Bearer \(authToken)"
        ]
        
        let formData: [String: Any] = [
            "image": image,
            "token": token,
            "delete_token": isDeletedToken
        ]
        
        ServerAccessor.shared.post(endpoint: Env.apiURL+Env.absentOUT,
                                   headers: headers,
                                   formData: formData) { result in
            switch result {
            case .success(let data):
                guard let jsonData = data as? Data else {
                    print("response bukan Data")
                    return
                }
                let responseModel = Helpers.shared.ParsingJsonToModel(AbsentOutResponse.self, from: jsonData)
                completion(.success(responseModel))
            case .failure(let failure):
                completion(.failure(failure))
            }
            
        }
    }
    
    func checkAbsentIN(
        id: String,
        lat: String,
        lon: String,
        completion: @escaping (_ result: AppResult<CheckAbsentInResponse?>) -> Void
    ) {
        let authToken = UserSettings.shared.getAuthToken() ?? ""
        let headers = [
            "Authorization": "Bearer \(authToken)"
        ]
        
        let formData = [
            "acara_id": id,
            "lat": lat,
            "long": lon
        ]
        
        ServerAccessor.shared.post(endpoint: Env.apiURL+Env.absentConditionIN,
                                   headers: headers,
                                   formData: formData) { result in
            switch result {
            case .success(let data):
                guard let jsonData = data as? Data else {
                    print("response bukan Data")
                    return
                }
                let responseModel = Helpers.shared.ParsingJsonToModel(CheckAbsentInResponse.self, from: jsonData)
                completion(.success(responseModel))
            case .failure(let failure):
                completion(.failure(failure))
            }
            
        }
    }
    
    func checkAbsentOUT(
        id: String,
        lat: String,
        lon: String,
        completion: @escaping (_ result: AppResult<CheckAbsentOutResponse?>) -> Void
    ) {
        let authToken = UserSettings.shared.getAuthToken() ?? ""
        let headers = [
            "Authorization": "Bearer \(authToken)"
        ]
        
        let formData = [
            "acara_id": id,
            "lat": lat,
            "long": lon
        ]
        
        ServerAccessor.shared.post(endpoint: Env.apiURL+Env.absentConditionOUT,
                                   headers: headers,
                                   formData: formData) { result in
            switch result {
            case .success(let data):
                guard let jsonData = data as? Data else {
                    print("response bukan Data")
                    return
                }
                let responseModel = Helpers.shared.ParsingJsonToModel(CheckAbsentOutResponse.self, from: jsonData)
                completion(.success(responseModel))
            case .failure(let failure):
                completion(.failure(failure))
            }
            
        }
    }
    
    func faceRegister(
        image: UIImage,
        completion: @escaping (_ result: AppResult<FaceRegisterResponse?>) -> Void
    ) {
        let authToken = UserSettings.shared.getAuthToken() ?? ""
        let headers = [
            "Authorization": "Bearer \(authToken)"
        ]
        
        let formData = [
            "image": image,
        ]
        
        ServerAccessor.shared.post(
            endpoint: Env.apiURL + Env.faceRegister,
            headers: headers,
            formData: formData
        ) { result in
            switch result {
            case .success(let data):
                guard let jsonData = data as? Data else {
                    print("response bukan Data")
                    return
                }
                let responseModel = Helpers.shared.ParsingJsonToModel(FaceRegisterResponse.self, from: jsonData)
                completion(.success(responseModel))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
        
    }
    
    func callCenter(
        completion: @escaping (_ result: AppResult<CallCenterResponse?>) -> Void
    ) {
        let authToken = UserSettings.shared.getAuthToken() ?? ""
        let headers = [
            "Authorization": "Bearer \(authToken)"
        ]
        
        ServerAccessor.shared.post(endpoint: Env.apiURL+Env.callCenter,headers: headers, formData: [:]) { result in
            switch result {
            case .success(let data):
                guard let jsonData = data as? Data else {
                    print("response bukan Data")
                    return
                }
                let responseModel = Helpers.shared.ParsingJsonToModel(CallCenterResponse.self, from: jsonData)
                completion(.success(responseModel))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
    
    func forgotPassword(
        name: String,
        nip: String,
        completion: @escaping (_ result: AppResult<ForgotPasswordResponse?>) -> Void
    ) {
        let authToken = UserSettings.shared.getAuthToken() ?? ""
        let headers = [
            "Authorization": "Bearer \(authToken)"
        ]
        
        let formData = [
            "nama": name,
            "nip": nip
        ]
        
        ServerAccessor.shared.post(endpoint: Env.apiURL+Env.forgotPassword,headers: headers, formData: formData) { result in
            switch result {
            case .success(let data):
                guard let jsonData = data as? Data else {
                    print("response bukan Data")
                    return
                }
                let responseModel = Helpers.shared.ParsingJsonToModel(ForgotPasswordResponse.self, from: jsonData)
                completion(.success(responseModel))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
    
    func registerFCMToken(token: String, completion: @escaping (_ result: AppResult<FCMTokenResponse?>) -> Void) {
        let authToken = UserSettings.shared.getAuthToken() ?? ""
        let headers = [
            "Authorization": "Bearer \(authToken)"
        ]
        
        let formData = [
            "fcm_token": token,
        ]
        
        print(formData)
        
        ServerAccessor.shared.post(endpoint: Env.apiURL+Env.fcmToken, headers: headers, formData: formData) { result in
            switch result {
            case .success(let data):
                guard let jsonData = data as? Data else {
                    print("response bukan Data")
                    return
                }
                let responseModel = Helpers.shared.ParsingJsonToModel(FCMTokenResponse.self, from: jsonData)
                completion(.success(responseModel))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
    
    func createAccount(name: String, username: String,password: String, password_confirmation: String, completion: @escaping (_ result: AppResult<LoginResponse?>) -> Void) {
        
        let formData = [
            "name": name,
            "username": username,
            "password": password,
            "password_confirmation": password_confirmation
        ]
        
        ServerAccessor.shared.post(endpoint: Env.apiURL+Env.register, formData: formData) { result in
            switch result {
            case .success(let data):
                guard let jsonData = data as? Data else {
                    print("response bukan Data")
                    return
                }
                let responseModel = Helpers.shared.ParsingJsonToModel(LoginResponse.self, from: jsonData)
                UserSettings.shared.setAuthToken(token: responseModel?.credential?.accessToken ?? "")
                UserSettings.shared.setIdentities(name: responseModel?.credential?.user?.name ?? "", role: responseModel?.credential?.user?.skpd ?? "", profile: responseModel?.credential?.user?.wajahURL ?? "", position: responseModel?.credential?.user?.jabatan ?? "")
                completion(.success(responseModel))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
    
    
}

enum AppResult<Model: Codable> {
    case success(Model)
    case failure(Error)
}


