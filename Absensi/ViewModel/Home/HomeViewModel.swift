//
//  HomeViewModel.swift
//  Absensi
//
//  Created by I putu Rama anadya on 21/09/23.
//

import SwiftUI

class HomeViewModel: ObservableObject {
    
    @Published var displayTodayEvent = true
    @Published var loading = false
    @Published var displayEvent = [EventEntity]()
    @Published var selectedEventID = 0
    
    private var todayEvent = [EventEntity]()
    private var upcomingEvent = [EventEntity]()
    
    private var totalpage = 999
    private var page = 1
    
    private var totalpage_upcoming = 999
    private var page_upcoming = 1
    
    @MainActor
    func showTodayEvent() {
        Helpers.shared.analyticsLog(itemID: "Home", itemName: "Menampilkan acara hari ini", contentType: .button)
        withAnimation(.spring(duration: 0.2)) {
            displayTodayEvent = true
            displayEvent = todayEvent
        }
        
        if todayEvent.isEmpty {
            refresh()
        }
    }
    
    @MainActor
    func showUpComingEvent() {
        Helpers.shared.analyticsLog(itemID: "Home", itemName: "Menampilkan acara akan datang", contentType: .button)
        withAnimation(.spring(duration: 0.2)) {
            displayTodayEvent = false
            displayEvent = upcomingEvent
        }
        if totalpage_upcoming == 999 {
            refresh()
        }
    }
    
    @MainActor
    func fetchEvent() {
        if page >= totalpage {
            print("Request data gagal. Sudah berada di halaman terakhir")
            return
        }
        
        loading = true
        
        NetworkRepository.shared.fetchEvent(
            page: page,
            perpage: Env.perpage) { result in
                switch result {
                case .success(let model):
                    self.loading = false
                    guard let event = model?.acara, let totalpage = model?.pagination?.totalPage else {
                        print("Acara kosong")
                        return
                    }
                    self.totalpage = totalpage
                    if self.page == 1 {
                        self.todayEvent = event
                    } else {
                        self.todayEvent.append(contentsOf: event)
                    }
                    self.page += 1
                    if self.displayTodayEvent {
                        self.displayEvent = self.todayEvent
                    }
                    return
                case .failure(_):
                    self.loading = false
                    return
                }
            }
    }
    
    @MainActor
    func fetchUpcomingEvent() {
        if page_upcoming >= totalpage_upcoming {
            print("Request data gagal. Sudah berada di halaman terakhir")
            return
        }
        
        loading = true
        
        NetworkRepository.shared.fetchUpComingEvent(
            page: page_upcoming,
            perpage: Env.perpage) { result in
                switch result {
                case .success(let model):
                    self.loading = false
                    guard let event = model?.acara, let totalpage = model?.pagination?.totalPage else {
                        print("Acara akan datang kosong")
                        return
                    }
                    self.totalpage_upcoming = totalpage
                    if self.page_upcoming == 1 {
                        self.upcomingEvent = event
                    } else {
                        self.upcomingEvent.append(contentsOf: event)
                    }
                    self.page_upcoming += 1
                    if !self.displayTodayEvent {
                        self.displayEvent = self.upcomingEvent
                    }
                    return
                case .failure(_):
                    self.loading = false
                    return
                }
            }
    }
    
    func registerFcmToken() {
        
        guard  let token = UserSettings.shared.getFCMToken() else {
            print("Token nil atau empty string\n")
            return
        }
        
        NetworkRepository.shared.registerFCMToken(token: token) { result in
            switch result {
            case .success(let model):
                print("Berhasil mengirim token notifikasi\n")
            case .failure(_):
                print("Gagal mengirim token notifikasi\n")
            }
        }
    }
    
    @MainActor 
    func refresh() {
        Helpers.shared.analyticsLog(itemID: "Home", itemName: "Merefresh halaman", contentType: .scroll)
        if displayTodayEvent {
            self.page = 1
            self.totalpage = 999
            self.fetchEvent()
        } else {
            self.page_upcoming = 1
            self.totalpage_upcoming = 999
            self.fetchUpcomingEvent()
        }
    }
    
}
