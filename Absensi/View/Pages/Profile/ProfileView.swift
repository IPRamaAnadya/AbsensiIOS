//
//  ProfileView.swift
//  Absensi
//
//  Created by I putu Rama anadya on 14/09/23.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        ScrollView {
            // List utama
            VStack {
                HStack(spacing: 20) {
                    Circle()
                        .frame(width: 60, height: 60, alignment: .center)
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Nama")
                            .fontWeight(.bold)
                        Text("NIP")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text("Jabatan")
                            .fontWeight(.bold)
                        Text("Bidang")
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
            NavigationLink(destination: {
                LoginView()
                    .navigationBarBackButtonHidden()
                    .navigationBarHidden(true)
            }, label: {
                ProfileMenu(
                    title: "Keluar",
                    subtitle: "Keluar sebagai Rama Anadya",
                    iconName: "info.circle")
            })
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
