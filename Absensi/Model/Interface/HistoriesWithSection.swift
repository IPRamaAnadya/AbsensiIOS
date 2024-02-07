//
//  HistoriesWithSection.swift
//  Absensi
//
//  Created by I putu Rama anadya on 27/09/23.
//

import Foundation

struct HistoriesWithSection: Codable,Identifiable {
    var id = UUID()
    let section: String
    let histories: [HistoryEntity]
}
