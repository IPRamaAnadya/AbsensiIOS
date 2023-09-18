//
//  CameraModel.swift
//  Absensi
//
//  Created by I putu Rama anadya on 16/09/23.
//

import SwiftUI
import AVFoundation

// Camera Model

class CameraModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    
    @Published var isTaken = false

    @Published var session = AVCaptureSession()
    
    @Published var alert = false
    
    @Published var output = AVCapturePhotoOutput()
    
    @Published var  preview: AVCaptureVideoPreviewLayer!
    
    @Published var picData = Data(count: 0)
    
    func check() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            
        case .notDetermined:
            // retusting for permission...
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { status in
                if status {
                    self.setUp()
                }
            })
        case .restricted:
            self.alert.toggle()
        case .denied:
            self.alert.toggle()
        case .authorized:
            setUp()
            // Setting up session
        @unknown default:
            return
        }
    }
    
    func setUp() {
        DispatchQueue.global(qos: .background).async {
            do {
                self.session.beginConfiguration()
                
                let device = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                     for: .video,
                                                     position: .front)
                
                let input = try AVCaptureDeviceInput(device: device!)
                
                if self.session.canAddInput(input) {
                    print("ADD INPUT...")
                    self.session.addInput(input)
                }
                
                if self.session.canAddOutput(self.output) {
                    print("ADD OUTPUT...")
                    self.session.addOutput(self.output)
                }
                
                self.session.commitConfiguration()
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func takePicture() {
        
        DispatchQueue.global(qos: .background).async {
            
            let settings = AVCapturePhotoSettings()
              let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first!
              let previewFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
                                   kCVPixelBufferWidthKey as String: 160,
                                   kCVPixelBufferHeightKey as String: 160]
              settings.previewPhotoFormat = previewFormat
            
            self.output.capturePhoto(with: settings, delegate: self)
//            self.session.stopRunning()
            
            DispatchQueue.main.async {
//                withAnimation { self.isTaken.toggle() }
            }
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if error != nil {
            print("CANT TAKE PICTURE...")
            print(error?.localizedDescription)
            return
        }
        
        print("PICTURE TAKEN...")
        
        guard let imageData = photo.fileDataRepresentation() else {return}
        
        self.picData = imageData
        
        self.savePicture()
    }
    
    func savePicture() {
        
        guard let image = UIImage(data: self.picData) else {
            print("IMAGE IS EMPTY...")
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        
        guard let imageData = image.jpegData(compressionQuality: 0.1) else {
            print("CANT COMPRESS IMAGE")
            return
        }
        
        guard let image2 = UIImage(data: imageData) else {
            print("IMAGE IS EMPTY...")
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(image2, nil, nil, nil)
        
        print("IMAGE SAVED IN PHOTOS...")
    }
}
