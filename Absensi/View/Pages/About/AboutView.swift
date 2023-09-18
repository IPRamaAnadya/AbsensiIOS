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
                Text("Aplikasi Absensi Wajah")
                    .fontWeight(.bold)
                Text("Aplikasi Absensi Wajah Lorem ipsum dolor sit amet, consectetur adipiscing elit. Commodo morbi sit lorem amet quis id et. Morbi massa, nisi, vestibulum ac. Eu mattis pellentesque ut volutpat consequat odio posuere. Sed mauris at non sagittis integer integer. Sollicitudin mauris sed elit rhoncus sit elit.")
                    .font(.caption)
                    .multilineTextAlignment(.leading)
                    .lineSpacing(10)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        .navigationTitle("Tentang Aplikasi")
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
