//
//  NotificationView.swift
//  Absensi
//
//  Created by I putu Rama anadya on 15/09/23.
//

import SwiftUI

struct NotificationView: View {
    var body: some View {
        ScrollView {
            VStack {
                ForEach(1..<5) { index in
                    Section {
                        Text("Hari \(index)")
                            .font(.caption)
                            .foregroundColor(Color.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 20)
                    }
                    ForEach(1..<5) { index2 in
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
                                    
                                    Text("Judul")
                                        .font(.body)
                                        .fontWeight(.bold)
                                        .foregroundColor(.black)
                                    Spacer()
                                    Text("Tanggal")
                                        .font(.caption)
                                        .foregroundColor(.black)
                                }
                                .frame(maxWidth: .infinity )
                                Text("Anda sudah dapat melakukan absen masuk pada kegiatan Bakti Sosial di Panti Asuhan Tabanan")
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
                        .animation(Animation.spring())
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        .navigationTitle("Notifikasi")
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            NotificationView()
        }
    }
}
