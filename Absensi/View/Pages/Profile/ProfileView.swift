//
//  ProfileView.swift
//  Absensi
//
//  Created by I putu Rama anadya on 14/09/23.
//

import SwiftUI

struct ProfileView: View {
    
    @State private var logout = false
    
    private let name = UserSettings.shared.getName() ?? ""
    private let profile = UserSettings.shared.getProfile() ?? ""
    private let role = UserSettings.shared.getRole() ?? ""
    private let position = UserSettings.shared.getPosition() ?? ""
    private let nip = UserSettings.shared.getUsername() ?? ""
    
    
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
            ProfileMenu(
                title: "Bantuan",
                subtitle: "Bantuan aplikasi",
                iconName: "questionmark.circle")
            
            NavigationLink(destination: {
                AboutView()
            }, label: {
                ProfileMenu(
                    title: "Tentang Aplikasi",
                    subtitle: "Versi aplikasi 1.0.0",
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
