//
//  ProfileView.swift
//  Absensi
//
//  Created by I putu Rama anadya on 14/09/23.
//

import SwiftUI

class ProfileViewModel: ObservableObject {
    
    @Published var callCenterResponse: CallCenterResponse?
    
    func callCenter(){
        NetworkRepository.shared.callCenter { result in
            switch result {
            case .success(let model):
                guard let model = model else {
                    return
                }
                self.callCenterResponse = model
            case .failure(_):
                return
            }
        }
    }
    
}


struct ProfileView: View {
    
    @State private var logout = false
    @ObservedObject private var vm = ProfileViewModel()
    private let name = UserSettings.shared.getName() ?? ""
    private let profile = UserSettings.shared.getProfile() ?? ""
    private let role = UserSettings.shared.getRole() ?? ""
    private let position = UserSettings.shared.getPosition() ?? ""
    private let nip = UserSettings.shared.getUsername() ?? ""
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    
    var body: some View {
        ScrollView {
            // List utama
            VStack {
                HStack(spacing: 20) {
                    Circle()
                        .frame(width: 60, height: 60, alignment: .center)
                        .overlay {
                            AsyncImage(url: URL(string: profile)){ image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } placeholder: {
                                Image(systemName: "photo.fill")
                            }
                            .frame(width: 60, height: 60)
                            .cornerRadius(60 / 2)
                        }
                        .clipped()
                    VStack(alignment: .leading, spacing: 10) {
                        Text(name)
                            .fontWeight(.bold)
                        Text(nip)
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text(position)
                            .fontWeight(.bold)
                        Text(role)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(25)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .shadow(color: .gray.opacity(0.15), radius: 10, x: -1, y: 10)
            // Akhir list utama
            
            // Profile Menu
            NavigationLink(destination: {
                HistoryView()
            }, label: {
                ProfileMenu(
                    title: "Riwayat Absen",
                    subtitle: "Riwayat absen anda",
                    iconName: "clock")
            })
            NavigationLink(destination: {
                UpdatePasswordView()
            }, label: {
                ProfileMenu(
                    title: "Ubah Kata Sandi",
                    subtitle: "Ubah kata sandi anda",
                    iconName: "repeat")
            })
            
            Link(destination: URL(string: vm.callCenterResponse?.callCenter?.url ?? "https://tabanankab.go.id/")!,
                 label: {
                ProfileMenu(
                    title: "Bantuan",
                    subtitle: "Bantuan aplikasi",
                    iconName: "questionmark.circle")
            })
            
            NavigationLink(destination: {
                AboutView()
            }, label: {
                ProfileMenu(
                    title: "Tentang Aplikasi",
                    subtitle: "Versi aplikasi \(appVersion ?? "")",
                    iconName: "info.circle")
            })
            
            Button(action: {
                UserSettings.shared.reset()
                logout = true
            }, label: {
                ProfileMenu(
                    title: "Keluar",
                    subtitle: "Keluar sebagai \(name)",
                    iconName: "info.circle")
            })
            .navigationDestination(isPresented: $logout, destination: {LoginView().navigationBarHidden(true)})
            // Akhir Profile Menu
            
        }
        .background(Color.gray.opacity(0.01))
        .onAppear {
            Helpers.shared.analyticsLog(itemID: "Profile", itemName: "Berada di halaman Profil", contentType: .automatic)
            vm.callCenter()
        }
        .onDisappear {
            Helpers.shared.analyticsLog(itemID: "Profile", itemName: "keluar dari halaman Profil", contentType: .automatic)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

struct ProfileMenu: View {
    
    let title: String
    let subtitle: String
    let iconName: String
    
    init(title: String, subtitle: String, iconName: String) {
        self.title = title
        self.subtitle = subtitle
        self.iconName = iconName
    }
    
    var body: some View {
        VStack {
            HStack(spacing: 20) {
                Image(systemName: iconName)
                    .foregroundColor(.gray)
                VStack(alignment: .leading, spacing: 10) {
                    Text(title)
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color.white)
            .cornerRadius(25)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
        .shadow(color: .gray.opacity(0.15), radius: 10, x: -1, y: 10)
    }
}
