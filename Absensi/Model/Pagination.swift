//
//  Pagination.swift
//  Absensi
//
//  Created by I putu Rama anadya on 20/09/23.
//

import Foundation

struct PaginationEntity: Codable {
    let totalData, perPage, currentPage, totalPage: Int?
    let nextPage: String?
    let prevPage: String?

    enum CodingKeys: String, CodingKey {
        case totalData = "total_data"
        case perPage = "per_page"
        case currentPage = "current_page"
        case totalPage = "total_page"
        case nextPage = "next_page"
        case prevPage = "prev_page"
    }
}
