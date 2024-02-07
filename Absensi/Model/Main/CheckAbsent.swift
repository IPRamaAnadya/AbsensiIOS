//
//  CheckAbsent.swift
//  Absensi
//
//  Created by I putu Rama anadya on 29/09/23.
//

import Foundation

struct CheckAbsent: Codable {
    let isSuccess: Bool?
    let message, token: String?

    enum CodingKeys: String, CodingKey {
        case isSuccess = "is_success"
        case message, token
    }
}
