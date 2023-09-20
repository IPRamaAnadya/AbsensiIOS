//
//  NotificationViewModel.swift
//  Absensi
//
//  Created by I putu Rama anadya on 20/09/23.
//

import SwiftUI

class NotificationViewModel: ObservableObject {
    
    @Published var loading = false
    @Published var notificationsWithSection: [NotificationWithSection] = []
    
    
    var notificationResponse: NotificationResponse = NotificationResponse(meta: nil, riwayatNotifikasi: nil, pagination: nil)
    private var page = 1
    
    @MainActor
    func fetchNotification() {
        
        if notificationResponse.pagination != nil {
            if page == notificationResponse.pagination?.totalPage ?? 1 {
                print("Sudah berada di page terakhir")
                return
            }
            
            if loading {
                print("Sedang memuat data..")
                return
            }
        }
        
        loading = true
        NetworkRepository.shared.fetchNotification(page: page, perpage: Env.perpage) { result in
            switch result {
            case .success(let model):
                self.loading = false
                guard let model = model else {
                    print("data kosong")
                    return
                }
                
                if(self.page == 1) {
                    self.notificationResponse = model
                } else {
                    self.notificationResponse.meta = model.meta
                    self.notificationResponse.pagination = model.pagination
                    
                    guard let notifications = model.riwayatNotifikasi, self.notificationResponse.riwayatNotifikasi != nil else {
                        return
                    }
                    self.notificationResponse.riwayatNotifikasi?.append(contentsOf: notifications)
                }
                
                self.page += 1
                withAnimation(.spring()) {
                    self.notificationsWithSection = Helpers.shared.parseNotificationResponse(self.notificationResponse)
                }
                
            case .failure(let error):
                self.loading = false
                print(error)
            }
        }
    }
    
    
}
