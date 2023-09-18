//
//  ForgotPasswordView.swift
//  Absensi
//
//  Created by I putu Rama anadya on 15/09/23.
//

import SwiftUI

struct ForgotPasswordView: View {
    
    @State var name = ""
    @State var nip = ""
    
    var body: some View {
        ScrollView {
            VStack {
                Text("Nama pegawai")
                    .fontWeight(.bold)
                    .padding(.horizontal, 20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 36)
                AppSecureField(text: $name, iconName: "person", hint: "Masukkan nama Anda...")
                Text("NIP")
                    .fontWeight(.bold)
                    .padding(.horizontal, 20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 10)
                AppSecureField(text: $name, iconName: "person.text.rectangle", hint: "Masukkan NIP Anda...")
                AppButton(title: "Konfirmasi", action: {})
                    .padding(.top, 50)
            }
        }
        .navigationBarTitle("Lupa Kata Sandi")
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ForgotPasswordView()
        }
    }
}
