//
//  UpdatePasswordView.swift
//  Absensi
//
//  Created by I putu Rama anadya on 15/09/23.
//

import SwiftUI

struct UpdatePasswordView: View {
    
    @State var oldPassword = ""
    @State var newPassword = ""
    @State var confirmPassword = ""
    var body: some View {
        ScrollView {
            VStack {
                Text("Kata sandi awal")
                    .fontWeight(.bold)
                    .padding(.horizontal, 20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 36)
                AppSecureField(text: $oldPassword, iconName: "lock", hint: "Masukkan kata sandi awal Anda...")
                Text("Kata sandi Baru")
                    .fontWeight(.bold)
                    .padding(.horizontal, 20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 36)
                AppSecureField(text: $newPassword, iconName: "lock", hint: "Masukkan kata sandi baru Anda...")
                AppSecureField(text: $confirmPassword, iconName: "lock", hint: "Konfirmasi kata sandi baru Anda...")
//                AppButton(title: "Konfirmasi", action: {})
//                    .padding(.top, 50)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
        }
        .navigationTitle("Ubah Kata Sandi")
    }
}

struct UpdatePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            UpdatePasswordView()
        }
    }
}
