//
//  FCMTokenResponse.swift
//  Absensi
//
//  Created by I putu Rama anadya on 18/10/23.
//

import SwiftUI

struct FCMTokenResponse: Codable {
    let meta: MetaEntity?

    enum CodingKeys: String, CodingKey {
        case meta
    }
}
