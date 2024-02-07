//
//  Env.swift
//  Absensi
//
//  Created by I putu Rama anadya on 19/09/23.
//

import Foundation


struct Env {
    
    static let baseURL = "http://103.183.75.217"
 
//    static let apiURL = "https://aum.tabanankab.go.id/api"
    // PRODUCTION
    static let apiURL = "\(baseURL)/api"
    
    //PATH
    static let loginPath = "/login"
    static let notificationPath = "/riwayat-notifikasi"
    static let eventPath = "/acara"
    static let historyPath = "/riwayat-absensi"
    static let changePassword = "/ubah-password"
    static let absentIN = "/absen-masuk"
    static let absentConditionIN = "/cek-kondisi-absen-masuk"
    static let absentOUT = "/absen-keluar"
    static let absentConditionOUT = "/cek-kondisi-absen-keluar"
    static let faceRegister = "/register-wajah"
    static let callCenter = "/call-center"
    static let forgotPassword = "/forgot-password-whatsapp"
    static let fcmToken = "/fcm-token"
    static let register = "/register"
    
    //STATIC VALUE
    static let perpage = 10
}
