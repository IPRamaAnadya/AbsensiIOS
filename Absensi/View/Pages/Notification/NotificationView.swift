//
//  NotificationView.swift
//  Absensi
//
//  Created by I putu Rama anadya on 15/09/23.
//

import SwiftUI

struct NotificationView: View {
    
    @ObservedObject private var vm = NotificationViewModel()
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(vm.notificationsWithSection, id: \.id) { section in
                    Section {
                        Text("\(section.section)")
                            .font(.caption)
                            .foregroundColor(Color.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 20)
                    }
                    Group {
                        ForEach(section.notifications, id: \.uuid) { notification in
                            HStack(spacing: 0){
                                Circle()
                                    .fill(Color("primary"))
                                    .frame(width: 30, height: 30, alignment: .center)
                                    .padding(.leading, 20)
                                    .overlay {
                                        Image(systemName: "bell.badge")
                                            .padding(.leading, 20)
                                            .foregroundColor(.white)
                                    }
                                VStack(spacing: 10) {
                                    HStack {
                                        
                                        Text(notification.title ?? "")
                                            .font(.body)
                                            .fontWeight(.bold)
                                            .foregroundColor(.black)
                                        Spacer()
                                        Text("\(Helpers.shared.dateFormatter(from: notification.createdAt ?? 0))")
                                            .font(.caption)
                                            .foregroundColor(.black)
                                    }
                                    .frame(maxWidth: .infinity )
                                    Text(notification.body ?? "")
                                        .font(.caption)
                                        .foregroundColor(.black)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    .frame(maxWidth: .infinity )
                                }.padding(.horizontal, 20)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical)
                            .background(Color.white)
                            .cornerRadius(15)
                            .overlay {
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.gray.opacity(0.05), lineWidth: 1.5)
                            }
                            .shadow(color: .gray.opacity(0.1), radius: 5, x: -1, y: 5)
    //                        .animation(Animation.spring())
                        }
                    }
                }
                Text("")
                    .onAppear() {
                        vm.fetchNotification()
                    }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        .navigationTitle("Notifikasi")
        .onAppear {
            Helpers.shared.analyticsLog(itemID: "Notifications", itemName: "Berada di halaman notifikasi", contentType: .automatic)
            vm.fetchNotification()
        }
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            NotificationView()
        }
    }
}
