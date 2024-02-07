//
//  AbsentEntity.swift
//  Absensi
//
//  Created by I putu Rama anadya on 29/09/23.
//

import Foundation

struct AbsentEntity: Codable {
    let isSuccess: Bool?
    let message: String?
    let isVerified: Bool?
    let distance: Double?
    let percentage: Int?

    enum CodingKeys: String, CodingKey {
        case isSuccess = "is_success"
        case message
        case isVerified = "is_verified"
        case distance, percentage
    }
}
