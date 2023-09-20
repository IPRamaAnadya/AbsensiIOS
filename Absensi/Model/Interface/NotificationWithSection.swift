//
//  NotificationWithSection.swift
//  Absensi
//
//  Created by I putu Rama anadya on 20/09/23.
//

import Foundation

struct NotificationWithSection: Codable,Identifiable {
    var id = UUID()
    let section: String
    let notifications: [NotificationEntity]
}
