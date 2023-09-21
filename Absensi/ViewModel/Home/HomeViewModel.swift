//
//  HomeViewModel.swift
//  Absensi
//
//  Created by I putu Rama anadya on 21/09/23.
//

import SwiftUI

class HomeViewModel: ObservableObject {
    
    @Published var displayTodayEvent = true
    
    @MainActor
    func showTodayEvent() {
        withAnimation(.spring()) { displayTodayEvent = true }
    }
    
    @MainActor
    func showNextDayEvent() {
        withAnimation(.spring()) { displayTodayEvent = false }
    }
    
}
