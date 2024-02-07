//
//  HistoryViewModel.swift
//  Absensi
//
//  Created by I putu Rama anadya on 27/09/23.
//

import SwiftUI

class HistoryViewModel: ObservableObject {
    
    @Published var loading = false
    @Published var histories = [HistoriesWithSection]()
    @Published var event: EventEntity?
    @Published var showSheet = false
    
    private var tempHistories = HistoriesResponse(meta: nil, riwayatAbsensi: nil, pagination: nil)
    private var page = 1
    
    
    
    @MainActor
    func fetchHistories() {
        
        if tempHistories.pagination != nil {
            guard let totalPage = tempHistories.pagination?.totalPage,
                    page < totalPage else {
                print("gagal memuat data. sudah berada pada halaman terakhir")
                return
            }
        }
        
        loading = true
        NetworkRepository.shared.fetchHistory(page: page, perpage: Env.perpage){ result in
            switch result {
            case .success(let model):
                self.loading = false
                guard let model = model, let histories = model.riwayatAbsensi else {
                    print("data history kosong")
                    return
                }
                
                if self.tempHistories.riwayatAbsensi == nil {
                    self.tempHistories = model
                } else {
                    self.tempHistories.meta = model.meta
                    self.tempHistories.pagination = model.pagination
                    self.tempHistories.riwayatAbsensi?.append(contentsOf: histories)
                }
                self.page += 1
                withAnimation(.spring()) {
                    self.histories = Helpers.shared.parseHistoriesResponse(self.tempHistories)
                }
                
            case .failure(_):
                self.loading = false
            }
        }
    }
    
    @MainActor
    func fetchSingleEvent(id: Int) {
        loading = true
        
        NetworkRepository.shared.fetchSingleEvent(id: id) { result in
            switch result {
            case .success(let model):
                guard let model = model, let event = model.acara else {
                    print("Detail acara kosong")
                    self.loading = false
                    return
                }
                self.event = event
                self.loading = false
                self.showSheet.toggle()
                Helpers.shared.analyticsLog(itemID: "History", itemName: "Melihat detail history", contentType: .automatic)
            case .failure(_):
                self.loading = false
            }
        }
    }
    
}
