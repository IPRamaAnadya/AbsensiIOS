//
//  FaceRegisterViewmodel.swift
//  Absensi
//
//  Created by I putu Rama anadya on 04/10/23.
//

import SwiftUI
import AVFoundation


class FaceRegisterViewmodel: NSObject, AVCapturePhotoCaptureDelegate, ObservableObject {
    
    @Published var taken = false

    @Published var session = AVCaptureSession()
    
    @Published var alert = false
    
    @Published var output = AVCapturePhotoOutput()
    
    @Published var  preview: AVCaptureVideoPreviewLayer!
    
    @Published var picData = Data(count: 0)
    
    @Published var loading = false
    
    @Published var perentage = 0
    
    @Published var showMessage = false
    @Published var title = ""
    @Published var message = ""
    
    @Published var gotToDashboard = false
    
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
                guard let device = AVCaptureDevice.default(
                                                            .builtInWideAngleCamera,
                                                            for: .video,
                                                            position: .front) else {
                    print("device kamera belum siap")
                    return
                }
                let input = try AVCaptureDeviceInput(device: device)
                if self.session.canAddInput(input) {
                    self.session.addInput(input)
                }
                if self.session.canAddOutput(self.output) {
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
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, willCapturePhotoFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
        AudioServicesDisposeSystemSoundID(1108)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if error != nil {
            print("Tidak bisa mengambil gambar")
            print(error?.localizedDescription ?? "")
            return
        }
        
        guard let imageData = photo.fileDataRepresentation() else {return}

        self.picData = imageData
        self.session.stopRunning()
        taken = true
        
    }
    
    func register() {
        if loading {
            showErrorMessage(message: "Proses sedang berjalan")
            return
        }
        
        if picData.count == 0 {
            showErrorMessage(message: "Gambar tidak ditemukan! Silahkan ambil gambar ulang")
            return
        }
        
        guard let image = UIImage(data: picData) else {
            showErrorMessage(message: "Gambar rusak! Silahkan ambil gambar ulang")
            return
        }
        
        withAnimation(.spring) {
            self.loading = true
        }
        
        NetworkRepository.shared.faceRegister(image: image) { result in
            switch result {
            case .success(let model):
                withAnimation(.spring) {
                    self.loading = false
                }
                guard let model = model else {
                    self.showErrorMessage(message: "Server tidak meresponse")
                    return
                }
                self.showSuccessMessage(message: "Registrasi wajah berhasil")
                
                UserSettings.shared.setIdentities(
                    name: model.user?.name ?? "", 
                    role: model.user?.skpd ?? "",
                    profile: model.user?.wajahURL ?? "",
                    position: model.user?.jabatan ?? "")
                
            case .failure(_):
                withAnimation(.spring) {
                    self.loading = false
                }
                self.showErrorMessage(message: "Wajah tidak terdeteksi")
            }
        }
    }
    
    func showErrorMessage(message: String) {
        title = "Gagal"
        self.message = message
        showMessage.toggle()
    }
    
    func showSuccessMessage(message: String) {
        title = "Berhasil"
        self.message = message
        showMessage.toggle()
    }
    
}
