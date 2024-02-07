//
//  AbsentOutResponse.swift
//  Absensi
//
//  Created by I putu Rama anadya on 02/10/23.
//

import Foundation


struct AbsentOutResponse: Codable {
    let meta: MetaEntity?
    let absenKeluar: AbsentEntity?

    enum CodingKeys: String, CodingKey {
        case meta
        case absenKeluar = "absen-keluar"
    }
}
