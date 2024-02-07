//
//  ForgotPasswordResponse.swift
//  Absensi
//
//  Created by I putu Rama anadya on 04/10/23.
//

import Foundation

struct ForgotPasswordResponse: Codable {
    let meta: MetaEntity?
    let forgotData: ForgotPasswordEntity?

    enum CodingKeys: String, CodingKey {
        case meta
        case forgotData = "forgot-password-whatsapp"
    }
}
