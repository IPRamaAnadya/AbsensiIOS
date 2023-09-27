//
//  HistoriesResponse.swift
//  Absensi
//
//  Created by I putu Rama anadya on 27/09/23.
//

import Foundation

struct HistoriesResponse: Codable {
    var meta: MetaEntity?
    var riwayatAbsensi: [EventEntity]?
    var pagination: PaginationEntity?

    enum CodingKeys: String, CodingKey {
        case meta
        case riwayatAbsensi = "riwayat_absensi"
        case pagination
    }
}
