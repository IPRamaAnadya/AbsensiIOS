//
//  HomeView.swift
//  Absensi
//
//  Created by I putu Rama anadya on 14/09/23.
//

import SwiftUI

struct HomeView: View {
    
    @State var showBottomSheet = false
    
    @ObservedObject private var vm = HomeViewModel()
    
    private let name = UserSettings.shared.getName() ?? ""
    private let profile = UserSettings.shared.getProfile() ?? ""
    
    var body: some View {
        ZStack {
            GeometryReader { reader in
                Color("primary")
                    .frame(height: reader.safeAreaInsets.top, alignment: .top)
                    .ignoresSafeArea()
            }
            VStack() {
                ZStack {
                    Rectangle()
                        .fill(Color("primary"))
                        .frame(height: 200, alignment: .top)
                        .overlay {
                            HStack(alignment: .top) {
                                HStack {
                                    Image("app_logo")
                                        .resizable()
                                        .frame(width: 24, height: 24, alignment: .center)
                                        .scaledToFit()
                                    Text("Absensi Kegiatan")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                }
                                Spacer()
                                NavigationLink(destination: {
                                    NotificationView()
                                }, label: {
                                    Image(systemName: "bell.badge")
                                        .foregroundColor(.white)
                                })
//                                Button(action: {
//                                    showBottomSheet.toggle()
//                                }, label: {
//                                    Image(systemName: "bell.badge")
//                                        .foregroundColor(.white)
//                                })
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                            .padding()
                        }
                    HStack {
                        Spacer(minLength: 20)
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.ultraThinMaterial)
                            .background(Color.white.opacity(0.3))
                            .cornerRadius(20)
                            .frame(maxHeight: 200)
                            .offset(y: 50)
                            .shadow(color: Color.gray.opacity(0.3), radius: 10, x: -1, y: 10)
                            .overlay {
                                VStack(spacing: 5) {
                                    Circle()
                                        .fill(Color.clear)
                                        .frame(width: 70)
                                        .overlay {
                                            AsyncImage(url: URL(string: profile)){ image in
                                                image
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                            } placeholder: {
                                                Image(systemName: "photo.fill")
                                            }
                                            .frame(width: 70, height: 70)
                                            .cornerRadius(70 / 2)
                                            
                                        }
                                        .clipped()
                                    Rectangle()
                                        .fill(Color.clear)
                                        .frame(height: 10)
                                    Text("Selamat datang")
                                        .font(.caption2)
                                    Text(name)
                                        .font(.footnote)
                                }
                                .offset(y: 50)
                            }
                        Spacer(minLength: 20)
                    }
                    .zIndex(200.0)
                }
                
                Rectangle()
                    .fill(Color.clear)
                    .frame(height: 60)
                
                HStack {
                    Spacer(minLength: 20)
                    Text("Hari ini")
                        .font(.footnote)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(vm.displayTodayEvent ? .white : .black)
                        .background(vm.displayTodayEvent ? Color("primary") : Color.white)
                        .cornerRadius(10)
                        .overlay {
                            if vm.displayTodayEvent {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color("primary").opacity(0.1), lineWidth: 0.5)
                            }
                        }
                        .shadow (
                            color: vm.displayTodayEvent ? .white : .gray.opacity(0.1),
                            radius: vm.displayTodayEvent ? 0 : 5,
                            x: vm.displayTodayEvent ? 0 : -1,
                            y: vm.displayTodayEvent ? 0 : 5)
                        .onTapGesture {
                            vm.showTodayEvent()
                        }
                    Text("Akan Datang")
                        .font(.footnote)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(!vm.displayTodayEvent ? .white : .black)
                        .background(!vm.displayTodayEvent ? Color("primary") : Color.white)
                        .cornerRadius(10)
                        .overlay {
                            if !vm.displayTodayEvent {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color("primary").opacity(0.1), lineWidth: 0.5)
                            }
                        }
                        .shadow (
                            color: !vm.displayTodayEvent ? .white : .gray.opacity(0.1),
                            radius: !vm.displayTodayEvent ? 0 : 5,
                            x: !vm.displayTodayEvent ? 0 : -1,
                            y: !vm.displayTodayEvent ? 0 : 5)
                        .onTapGesture {
                            vm.showUpComingEvent()
                        }
                    
                    Spacer(minLength: 20)
                }
                
                if vm.displayEvent.isEmpty {
                    ScrollView {
                        Text("Tidak ada acara")
                            .foregroundColor(.gray)
                            .padding(.top, 50)
                    }
                    .refreshable {
                        vm.refresh()
                    }
                } else {
                    ScrollView {
                        VStack {
                            ForEach(vm.displayEvent, id:\.uuid) {event in
                                Button(action: {
                                    Helpers.shared.analyticsLog(itemID: "Home", itemName: "Menampilkan detail acara: \(event.nama ?? "")", contentType: .card)
                                    vm.selectedEventID = event.id ?? 0
                                    showBottomSheet.toggle()
                                }, label: {
                                    HStack(spacing: 0){
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color(
                                                event.status == 1 || event.status == 2
                                                ? "ongoing"
                                                : event.status == 3
                                                ? "ongoing_wait"
                                                : event.status == 4
                                                ? "primary"
                                                : "not_start"
                                            ))
                                            .frame(maxWidth: 20)
                                            .frame(height: 50)
                                            .offset(x: -10)
                                        VStack(spacing: 10) {
                                            HStack {
                                                Text(event.nama ?? "")
                                                    .font(.body)
                                                    .fontWeight(.bold)
                                                    .foregroundColor(.black)
                                                Spacer()
                                                Text("\(Helpers.shared.dateFormatter(from: event.tanggalEpoch ?? 0))")
                                                    .font(.caption)
                                                    .foregroundColor(.black)
                                            }
                                            .frame(maxWidth: .infinity )
                                            HStack {
                                                HStack {
                                                    Image(systemName: "mappin.and.ellipse")
                                                        .foregroundColor(.gray)
                                                    Text(event.tempat ?? "")
                                                        .font(.caption)
                                                        .foregroundColor(.black)
                                                }
                                                Spacer()
                                                Text("\(Helpers.shared.timeFormatter(from: event.absenMasukMulaiEpoch ?? 0))")
                                                    .font(.caption)
                                                    .foregroundColor(.black)
                                            }
                                            .frame(maxWidth: .infinity )
                                        }.padding(.trailing, 10)
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
                                })
                            }
                            Text("")
                                .onAppear {
                                    vm.fetchEvent()
                                }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(maxHeight: .infinity, alignment: .top)
                        .padding()
                
                    }
                    .refreshable {
                        vm.refresh()
                    }
                    .sheet(isPresented: $showBottomSheet) {
                        NavigationStack {
                            DetailEventView(isPresented: $showBottomSheet, eventID: vm.selectedEventID)
                        }
                    }
                    
                }
                
            }
            .onAppear {
                Helpers.shared.analyticsLog(itemID: "Home", itemName: "Berada di halaman beranda", contentType: .automatic)
                vm.fetchEvent()
                vm.registerFcmToken()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
