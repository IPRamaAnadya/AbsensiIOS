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
    private var totalpage = 10
    private var page = 1
    
    @MainActor
    func showTodayEvent() {
        withAnimation(.spring()) { displayTodayEvent = true }
    }
    
    @MainActor
    func showNextDayEvent() {
        withAnimation(.spring()) { displayTodayEvent = false }
    }
    
    @MainActor
    func fetchEvent() {
        if page == totalpage {
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
                    self.page += 1
                    return
                case .failure(let error):
                    self.loading = false
                    return
                }
            }
    }
    
}
