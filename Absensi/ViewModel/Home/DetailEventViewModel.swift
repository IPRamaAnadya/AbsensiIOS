//
//  DetailEventViewModel.swift
//  Absensi
//
//  Created by I putu Rama anadya on 27/09/23.
//

import SwiftUI

class DetailEventViewModel: ObservableObject {
    
    @Published var loading = true
    @Published var canAbsentIN = false
    @Published var canAbsentOUT = false
    @Published var event: EventEntity?
    
    @Published var absentIN = false
    @Published var absentOUT = false
    
    @MainActor
    func fetchSingleEvent(id: Int) {
        loading = true
        
        NetworkRepository.shared.fetchSingleEvent(id: id) { result in
            switch result {
            case .success(let model):
                guard let event = model?.acara else {
                    print("Data acara kosong")
                    return
                }
                withAnimation(.spring()) {
                    self.event = event
                    self.loading = false
                    self.checkAbsentState()
                }
            case .failure(let error):
                self.loading = false
            }
        }
    }
    
    @MainActor
    func checkAbsentState() {
        guard let event = self.event else {
            print("Event kosong")
            return
        }
        
        let currentDate = Int(Date().timeIntervalSince1970)
        
        if currentDate >= (event.absenMasukMulaiEpoch ?? 0), currentDate <= (event.absenMasukSelesaiEpoch ?? 0), event.absenMasukAtEpoch == nil {
            self.canAbsentIN = true
        }
        
        if currentDate >= (event.absenKeluarMulaiEpoch ?? 0), currentDate <= (event.absenKeluarSelesaiEpoch ?? 0), event.absenKeluarAtEpoch == nil {
            self.canAbsentOUT = true
        }
    }
}
