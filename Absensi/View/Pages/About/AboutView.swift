//
//  AboutView.swift
//  Absensi
//
//  Created by I putu Rama anadya on 15/09/23.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Absensi Kegiatan Tabanan")
                    .fontWeight(.bold)
                Text("Aplikasi ini digunakan untuk melakukan absensi menggunakan wajah di setiap kegiatan yang ada.")
                    .font(.caption)
                    .multilineTextAlignment(.leading)
                    .lineSpacing(10)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        .navigationTitle("Tentang Aplikasi")
        .onAppear {
            Helpers.shared.analyticsLog(itemID: "About", itemName: "berada di halaman about", contentType: .automatic)
        }
        .onDisappear {
            Helpers.shared.analyticsLog(itemID: "About", itemName: "keluar dari halaman about", contentType: .automatic)
        }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
