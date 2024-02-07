//
//  CameraModel.swift
//  Absensi
//
//  Created by I putu Rama anadya on 16/09/23.
//

import SwiftUI
import AVFoundation

// Camera Model

class AbsentModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    
    @Published var isTaken = false

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
    
    @Published var eventData: EventEntity?
    private var checkAbsent: CheckAbsent?
    private var absentsResponse = [AbsentInResponse]()
    
    private let MAX_LOOP = 5
    private var loop = 1
    
    private var absentIn = true
    
    func dispose() {
        session.stopRunning()
        loading = false
        perentage = 0
        showMessage = false
        title = ""
        message = ""
        eventData = nil
        checkAbsent = nil
        absentsResponse = []
        absentIn = true
    }
    
    
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
        
        self.loading = true
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
        
        if absentIn {
            self.requestAbsentIn()
        } else {
            self.requestAbsentOut()
        }
        
    }
    
    func requestAbsentIn() {
        guard let image = UIImage(data: self.picData) else {
            self.title = "Gagal"
            self.message = "Gambar tidak dapat di proses"
            self.showMessage.toggle()
            self.session.stopRunning()
            return
        }
        
        guard let token = checkAbsent?.token, token != "" else {
            print("Token tidak ada")
            self.title = "Gagal"
            self.message = checkAbsent?.message ?? "Token absen tidak ditemukan"
            self.showMessage.toggle()
            self.session.stopRunning()
            return
        }
        
        if self.loop >= self.MAX_LOOP {
            self.title = "Gagal"
            self.message = "Wajah tidak dikenali"
            self.showMessage.toggle()
            self.session.stopRunning()
            return
        }
        
        NetworkRepository.shared.absentIn(
            image: image,
            token: token,
            isDeletedToken: loop >= MAX_LOOP ? "1" : "0") 
        { result in
            
            switch result {
            case .success(let model):
                guard let model = model else {
                    print("Data absensi kosong")
                    self.title = "Gagal"
                    self.message = "Server tidak menanggapi"
                    self.showMessage.toggle()
                    self.session.stopRunning()
                    return
                }
                if model.absenMasuk?.isVerified == true {
                    print("Absen sukses")
                    self.title = "Berhasil"
                    self.message = "Absen berhasil"
                    self.showMessage.toggle()
                    self.session.stopRunning()
                } else {
                    print("Absen gagal")
                    print(model.absenMasuk?.message ?? "")
                    withAnimation(.spring(duration: 0.6, bounce: 0.5, blendDuration: 0.5)) {
                        self.perentage = model.absenMasuk?.percentage ?? 0
                    }
                    self.loop += 1
                    if self.loop > self.MAX_LOOP {
                        return
                    }
                    print("Ulang ke \(self.loop)")
                    self.takePicture()
                }
            case .failure(_):
                print("Gagal absent")
                self.title = "Gagal"
                self.message = "Terjadi kesalahan saat memproses absen"
                self.showMessage.toggle()
                self.session.stopRunning()
                self.loading = false
            }
        }
    }
    
    func requestAbsentOut() {
        guard let image = UIImage(data: self.picData) else {
            self.title = "Gagal"
            self.message = "Gambar tidak dapat di proses"
            self.showMessage.toggle()
            self.session.stopRunning()
            return
        }
        
        guard let token = checkAbsent?.token, token != "" else {
            print("Token tidak ada")
            self.title = "Gagal"
            self.message = checkAbsent?.message ?? "Token absen tidak ditemukan"
            self.showMessage.toggle()
            self.session.stopRunning()
            return
        }
        
        if self.loop >= self.MAX_LOOP {
            self.title = "Gagal"
            self.message = "Wajah tidak dikenali"
            self.showMessage.toggle()
            self.session.stopRunning()
            return
        }
        
        NetworkRepository.shared.absentOUT(
            image: image,
            token: token,
            isDeletedToken: loop >= MAX_LOOP ? "1" : "0")
        { result in
            
            switch result {
            case .success(let model):
                guard let model = model else {
                    print("Data absensi kosong")
                    self.title = "Gagal"
                    self.message = "Server tidak menanggapi"
                    self.showMessage.toggle()
                    self.session.stopRunning()
                    return
                }
                if model.absenKeluar?.isVerified == true {
                    print("Absen sukses")
                    self.title = "Berhasil"
                    self.message = "Absen berhasil"
                    self.showMessage.toggle()
                    self.session.stopRunning()
                } else {
                    print("Absen gagal")
                    print(model.absenKeluar?.message ?? "")
                    withAnimation(.spring(duration: 0.6, bounce: 0.5, blendDuration: 0.5)) {
                        self.perentage = model.absenKeluar?.percentage ?? 0
                    }
                    self.loop += 1
                    if self.loop > self.MAX_LOOP {
                        return
                    }
                    print("Ulang ke \(self.loop)")
                    self.takePicture()
                }
            case .failure(_):
                print("Gagal absent")
                self.title = "Gagal"
                self.message = "Terjadi kesalahan saat memproses absen"
                self.showMessage.toggle()
                self.session.stopRunning()
                self.loading = false
            }
        }
    }
    
    func setEvent(event: EventEntity) {
        self.eventData = event
    }
    
    func checkAbsentIN() {
        guard let event = self.eventData else {
            print("Data event tidak ditemukan")
            return
        }
        
        loading = true
        loop = 1
        
        NetworkRepository.shared.checkAbsentIN(
            id  : event.id?.description ?? "0",
            lat : event.lat?.description ?? "0",
            lon : event.long?.description ?? "0") 
        { result in
            switch result {
            case .success(let data):
                guard let checkAbsent = data?.cekAbsenMasuk else {
                    print("data check absent kosong")
                    return
                }
                self.checkAbsent = checkAbsent
                self.takePicture()
                self.absentIn = true
            case .failure(let error):
                print("terjadi kesalahan saat mengecek absen\n\(error)")
            }
        }
    }
    
    func checkAbsentOUT() {
        guard let event = self.eventData else {
            print("Data event tidak ditemukan")
            return
        }
        
        loading = true
        loop = 1
        
        NetworkRepository.shared.checkAbsentOUT(
            id  : event.id?.description ?? "0",
            lat : event.lat?.description ?? "0",
            lon : event.long?.description ?? "0")
        { result in
            switch result {
            case .success(let data):
                guard let checkAbsent = data?.cekAbsenKeluar else {
                    print("data check absent kosong")
                    return
                }
                self.checkAbsent = checkAbsent
                self.takePicture()
                self.absentIn = false
            case .failure(let error):
                print("terjadi kesalahan saat mengecek absen\n\(error)")
            }
        }
    }
}
