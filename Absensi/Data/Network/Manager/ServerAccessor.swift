//
//  ServerAccessor.swift
//  Absensi
//
//  Created by I putu Rama anadya on 19/09/23.
//

import Foundation
import UIKit
import Alamofire

class ServerAccessor {
    
    static let shared = ServerAccessor()
    
    private init() {}
    
    /// Request POST to server
    /// - Parameters:
    ///   - endpoint: Url yang dituju
    ///   - formData: Data yang ingin dikirimkan
    ///   - completion: response berupa json dan error
    func post(endpoint: String, formData: [String: Any], completion: @escaping (Result<Any, Error>) -> Void) {
        guard let url = URL(string: endpoint) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let httpBody = createMultipartBody(with: formData, boundary: boundary)
        request.httpBody = httpBody
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Request error")
                    completion(.failure(error))
                    return
                }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    print("Request code not 200")
                    completion(.failure(NSError(domain: "Request not Success", code: -1, userInfo: nil)))
                    return
                }
                
                guard let data = data else {
                    print("No data received")
                    completion(.failure(NSError(domain: "No data received", code: -2, userInfo: nil)))
                    return
                }
                
                completion(.success(data))
            }
        }.resume()
    }

    private func createMultipartBody(with formData: [String: Any], boundary: String) -> Data {
        var body = Data()

        for (key, value) in formData {
            body.append(convertStringToFormData(string: "--\(boundary)\r\n"))
            body.append(convertStringToFormData(string: "Content-Disposition: form-data; name=\"\(key)\""))

            if let image = value as? UIImage {
                let mimeType = "image/jpeg"
                body.append(convertStringToFormData(string: "; filename=\"image.jpg\"\r\n"))
                body.append(convertStringToFormData(string: "Content-Type: \(mimeType)\r\n\r\n"))
                body.append(convertUIImageToFormData(image: image))
            } else if let data = value as? Data {
                body.append(convertStringToFormData(string: "\r\n\r\n"))
                body.append(data)
            } else if let string = value as? String {
                body.append(convertStringToFormData(string: "\r\n\r\n"))
                body.append(convertStringToFormData(string: string))
            }

            body.append(convertStringToFormData(string: "\r\n"))
        }

        body.append(convertStringToFormData(string: "--\(boundary)--\r\n"))

        return body
    }

    private func convertUIImageToFormData(image: UIImage) -> Data {
        let imageData = image.jpegData(compressionQuality: 0.2) ?? Data(count: 0)
        return imageData
    }

    private func convertDataToFormData(data: Data) -> Data {
        return data
    }

    private func convertStringToFormData(string: String) -> Data {
        let stringData = string.data(using: .utf8)!
        return stringData
    }
    
    

    func get<T: Decodable>(
        endpoint: String,
        to type: T.Type,
        headers: [String: String] = [:],
        params: [String: String] = [:],
        completion: @escaping (AppResult<T>) -> Void)
    {
        
        let httpHeaders = HTTPHeaders(headers)
        AF.request(endpoint, parameters: params, headers: httpHeaders)
            .responseDecodable(of: type) { response in
                
                print("\n\nREQUEST::GET")
                print("Endpoint: \(response.request?.description ?? "")")
                print("\(response.response?.headers.description ?? "")")
                print("\n\nEND REQUEST")
                
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
