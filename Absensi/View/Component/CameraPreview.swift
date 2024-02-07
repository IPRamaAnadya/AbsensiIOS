//
//  CameraPreview.swift
//  Absensi
//
//  Created by I putu Rama anadya on 16/09/23.
//

import SwiftUI
import AVFoundation

struct CameraPreview: UIViewRepresentable {
    
    @ObservedObject var camera : AbsentModel
    
    func makeUIView(context: Context) -> some UIView {
        
        let view = UIView(frame: UIScreen.main.bounds)
        
        camera.preview = AVCaptureVideoPreviewLayer(session: camera.session)
        camera.preview.frame = view.frame
        
        camera.preview.videoGravity = .resizeAspectFill
        view.layer.addSublayer(camera.preview)
        
        DispatchQueue.global(qos: .background).async {
            self.camera.session.startRunning()
        }
        
        return view
        
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        print("UPDATING UIVIEW...")
    }
    
}


struct CameraPreview2: UIViewRepresentable {
    
    @ObservedObject var camera : FaceRegisterViewmodel
    
    func makeUIView(context: Context) -> some UIView {
        
        let view = UIView(frame: UIScreen.main.bounds)
        
        camera.preview = AVCaptureVideoPreviewLayer(session: camera.session)
        camera.preview.frame = view.frame
        
        camera.preview.videoGravity = .resizeAspectFill
        view.layer.addSublayer(camera.preview)
        
        DispatchQueue.global(qos: .background).async {
            self.camera.session.startRunning()
        }
        
        return view
        
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        print("UPDATING UIVIEW...")
    }
    
}
