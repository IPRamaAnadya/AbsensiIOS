//
//  PrivacyPolice.swift
//  Absensi
//
//  Created by I putu Rama anadya on 21/11/23.
//

import SwiftUI

struct PrivacyPoliceView: View {
    
    @State var isloading = false
    @Binding var agree: Bool
    @Binding var showPrivacyPolice: Bool
    
    init(agree: Binding<Bool>, showPrivacyPolice: Binding<Bool>) {
        self._agree = agree
        self._showPrivacyPolice = showPrivacyPolice
    }
    
    
    private var url: URL {
        let urlString = "\(Env.baseURL)/privacy-policy"
        let url = URL(string: urlString)
        return url!
    }
    var body: some View {
        VStack {
            WebView(url: url, isLoading: $isloading)
                .frame(height: .infinity)
                .frame(width: .infinity)
            Toggle(isOn: $agree) {
                Text("Agree to Privacy Policy")
            }
            .padding(20)
            AppButton(title: "Continue", showLoading: $isloading) {
                showPrivacyPolice.toggle()
            }
        }
    }
}

//#Preview {
//    PrivacyPoliceView()
//}
