//
//  LottieView.swift
//  Absensi
//
//  Created by I putu Rama anadya on 16/09/23.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    
    var name: String
    
    func makeUIView(context: Context) -> some UIView {
        let animationView = LottieAnimationView(name: name)
        animationView.play()
        
        return animationView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        print("UDATE UIVIEW...")
    }
}

