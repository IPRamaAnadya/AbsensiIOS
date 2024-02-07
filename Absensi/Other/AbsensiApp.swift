//
//  AbsensiApp.swift
//  Absensi
//
//  Created by I putu Rama anadya on 14/09/23.
//

import SwiftUI


@main
struct AbsensiApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
