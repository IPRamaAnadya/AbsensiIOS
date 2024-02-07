//
//  CheckAbsentOutResponse.swift
//  Absensi
//
//  Created by I putu Rama anadya on 02/10/23.
//

import Foundation

struct CheckAbsentOutResponse: Codable {
    let meta: MetaEntity?
    let cekAbsenKeluar: CheckAbsent?

    enum CodingKeys: String, CodingKey {
        case meta
        case cekAbsenKeluar = "cek-absen-keluar"
    }
}
