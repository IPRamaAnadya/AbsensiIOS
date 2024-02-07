//
//  AbsentInResponse.swift
//  Absensi
//
//  Created by I putu Rama anadya on 29/09/23.
//

import Foundation

struct AbsentInResponse: Codable {
    let meta: MetaEntity?
    let absenMasuk: AbsentEntity?

    enum CodingKeys: String, CodingKey {
        case meta
        case absenMasuk = "absen-masuk"
    }
}
