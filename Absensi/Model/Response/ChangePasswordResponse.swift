//
//  ChangePasswordResponse.swift
//  Absensi
//
//  Created by I putu Rama anadya on 29/09/23.
//

import Foundation

struct ChangePasswordResponse: Codable {
    let meta: MetaEntity?
    let user: UserEntity?
}
