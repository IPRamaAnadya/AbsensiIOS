//
//  NotificationResponse.swift
//  Absensi
//
//  Created by I putu Rama anadya on 20/09/23.
//

import Foundation

struct NotificationResponse: Codable {
    var meta: MetaEntity?
    var riwayatNotifikasi: [NotificationEntity]?
    var pagination: PaginationEntity?

    enum CodingKeys: String, CodingKey {
        case meta
        case riwayatNotifikasi = "riwayat-notifikasi"
        case pagination
    }
}
