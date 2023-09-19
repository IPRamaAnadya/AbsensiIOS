//
//  CreatePasswordView.swift
//  Absensi
//
//  Created by I putu Rama anadya on 15/09/23.
//

import SwiftUI

struct CreatePasswordView: View {
    
    @State var newPassword = ""
    @State var confirmPassword = ""
    @State var showLoading = false
    
    var body: some View {
        ScrollView {
            VStack {
                AppSecureField(text: $newPassword, iconName: "lock", hint: "Masukkan kata sandi Anda...")
                    .padding(.top, 40)
                AppSecureField(text: $confirmPassword, iconName: "lock", hint: "Konfirmasi kata sandi Anda...")
                AppButton(title: "Konfirmasi",showLoading: $showLoading, action: {})
                    .padding(.top, 50)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
        }
        .navigationTitle("Buat Kata Sandi")
    }
}

struct CreatePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CreatePasswordView()
        }
    }
}
