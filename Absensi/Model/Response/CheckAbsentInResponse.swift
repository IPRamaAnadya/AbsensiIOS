//
//  CheckAbsentInResponse.swift
//  Absensi
//
//  Created by I putu Rama anadya on 29/09/23.
//

import Foundation

struct CheckAbsentInResponse: Codable {
    let meta: MetaEntity?
    let cekAbsenMasuk: CheckAbsent?

    enum CodingKeys: String, CodingKey {
        case meta
        case cekAbsenMasuk = "cek-absen-masuk"
    }
}
