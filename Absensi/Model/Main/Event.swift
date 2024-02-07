//
//  Event.swift
//  Absensi
//
//  Created by I putu Rama anadya on 27/09/23.
//

import Foundation

struct EventEntity: Codable, Identifiable {
    let uuid = UUID()
    let id: Int?
    let nama, deskripsi, tempat, lat: String?
    let long: String?
    let radius, tanggalEpoch, absenMasukMulaiEpoch, absenMasukSelesaiEpoch: Int?
    let absenKeluarMulaiEpoch, absenKeluarSelesaiEpoch, status, tanggal: Int?
    let kuotaTerpakai, kuotaTersisa, totalKuota, kuotaTakTerbatas: Int?
    let absenMasukAtEpoch, absenKeluarAtEpoch: Int?

    enum CodingKeys: String, CodingKey {
        case id, nama, deskripsi, tempat, lat, long, radius
        case tanggalEpoch = "tanggal_epoch"
        case absenMasukMulaiEpoch = "absen_masuk_mulai_epoch"
        case absenMasukSelesaiEpoch = "absen_masuk_selesai_epoch"
        case absenKeluarMulaiEpoch = "absen_keluar_mulai_epoch"
        case absenKeluarSelesaiEpoch = "absen_keluar_selesai_epoch"
        case status, tanggal
        case kuotaTerpakai = "kuota_terpakai"
        case kuotaTersisa = "kuota_tersisa"
        case totalKuota = "total_kuota"
        case kuotaTakTerbatas = "kuota_tak_terbatas"
        case absenMasukAtEpoch = "absen_masuk_at_epoch"
        case absenKeluarAtEpoch = "absen_keluar_at_epoch"
    }
}
