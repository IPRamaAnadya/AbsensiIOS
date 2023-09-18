//
//  AbsentSuccessView.swift
//  Absensi
//
//  Created by I putu Rama anadya on 16/09/23.
//

import SwiftUI
import Lottie

struct AbsentSuccessView: View {
    
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack {
            Spacer()
            LottieView(name: "success_animation")
                .scaleEffect(0.5)
                .frame(width: 300)
                .frame(height: 300)
            Text("Absen Berhasil")
            Spacer()
            Button(action: {
                isPresented = false
            }, label: {
                Text("Kembali ke menu utama")
                    .foregroundColor(Color("primary"))
            })
        }
        .navigationBarHidden(true)
    }
}

struct AbsentSuccessView_Previews: PreviewProvider {
    static var previews: some View {
        @State var example = false
        AbsentSuccessView(isPresented: $example)
    }
}
