//
//  Credential.swift
//  Absensi
//
//  Created by I putu Rama anadya on 19/09/23.
//

import Foundation

struct CredentialEntity: Codable {
    let accessToken, tokenType: String?
    let user: UserEntity?

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case user
    }
}
