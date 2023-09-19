//
//  LoginResponse.swift
//  Absensi
//
//  Created by I putu Rama anadya on 19/09/23.
//

import Foundation

struct LoginResponse: Codable {
    let meta: MetaEntity?
    let credential: CredentialEntity?
}
