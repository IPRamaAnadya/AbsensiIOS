//
//  CallCenterResponse.swift
//  Absensi
//
//  Created by I putu Rama anadya on 04/10/23.
//

import Foundation

struct CallCenterResponse: Codable {
    let meta: MetaEntity?
    let callCenter: CallCenterEntity?

    enum CodingKeys: String, CodingKey {
        case meta
        case callCenter = "call-center"
//        case forgotPasswordWhatsapp = "forgot-password-whatsapp"
    }
}
