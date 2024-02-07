//
//  AllEventsResponse.swift
//  Absensi
//
//  Created by I putu Rama anadya on 27/09/23.
//

import Foundation

struct AllEventsResponse: Codable {
    let meta: MetaEntity?
    let acara: [EventEntity]?
    let pagination: PaginationEntity?
}
