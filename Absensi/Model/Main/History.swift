//
//  History.swift
//  Absensi
//
//  Created by I putu Rama anadya on 27/09/23.
//

import Foundation

struct HistoryEntity: Codable {
    let uuid = UUID()
    let id, acaraID: Int?
    let nama: String?
    let tempat: String?
    let tanggal, waktu: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case acaraID = "acara_id"
        case nama, tempat, tanggal, waktu
    }
}
