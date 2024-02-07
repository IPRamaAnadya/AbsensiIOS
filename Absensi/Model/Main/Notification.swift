//
//  Notification.swift
//  Absensi
//
//  Created by I putu Rama anadya on 20/09/23.
//

import Foundation

struct NotificationEntity: Codable, Identifiable {
    var uuid = UUID()
    let id: Int?
    let title, body, url: String?
    let createdAt: Int?

    enum CodingKeys: String, CodingKey {
        case id, title, body, url
        case createdAt = "created_at"
    }
}

