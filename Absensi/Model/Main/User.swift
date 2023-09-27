//
//  UserEnity.swift
//  Absensi
//
//  Created by I putu Rama anadya on 19/09/23.
//

import Foundation

// MARK: - User
struct UserEntity: Codable {
    let id: Int?
    let name, nip, idSkpd, skpd: String?
    let idJabatan, jabatan: String?
    let telahDaftarWajah, telahUbahPassword: Bool?
    let wajahURL: String?
    let profilePhotoURL: String?

    enum CodingKeys: String, CodingKey {
        case id, name, nip
        case idSkpd = "id_skpd"
        case skpd
        case idJabatan = "id_jabatan"
        case jabatan
        case telahDaftarWajah = "telah_daftar_wajah"
        case telahUbahPassword = "telah_ubah_password"
        case wajahURL = "wajah_url"
        case profilePhotoURL = "profile_photo_url"
    }
}
