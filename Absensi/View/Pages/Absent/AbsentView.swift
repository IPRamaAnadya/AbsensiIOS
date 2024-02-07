//
//  AbsentView.swift
//  Absensi
//
//  Created by I putu Rama anadya on 15/09/23.
//

import SwiftUI
import AVFoundation

struct AbsentView: View {
    
    @StateObject var camera: AbsentModel = AbsentModel()
    @ObservedObject private var lvm: LocationViewModel
    @Binding var isPresented: Bool
    private var event: EventEntity
    private var state: AbsentState
    
    init(isPresented: Binding<Bool>,
         event: EventEntity,
         state: AbsentState
    ) {
        self.lvm = LocationViewModel()
        self._isPresented = isPresented
        self.event = event
        self.state = state
    }
    
    func absentAction(){
        if lvm.checkUserInRadius(lat: camera.eventData?.lat ?? "0", lon: camera.eventData?.long ?? "0", radius: camera.eventData?.radius ?? 0) {
            switch state {
            case .absent_in:
                camera.checkAbsentIN()
            case .absent_out:
                camera.checkAbsentOUT()
            }
        } else {
            Helpers.shared.analyticsLog(itemID: "Absen", itemName: "User gagal absen karena berada diluar radius", contentType: .automatic)
            camera.title = "Gagal"
            camera.message = "Kamu berada di luar radius"
            camera.showMessage.toggle()
        }
    }
    
    var body: some View {
        ZStack {
            CameraPreview(camera: camera)
//            Color.black
                .ignoresSafeArea()
            
            Text("Pastikan Wajah Anda\nBerada dalam Lingkaran")
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.top, 30)
                .multilineTextAlignment(.center)
                .frame(maxHeight: .infinity, alignment: .top)
            
            Ellipse()
                .stroke(style: StrokeStyle(lineWidth: 5, dash: [20] ))
                .foregroundColor(.white)
                .frame(width: UIScreen.main.bounds.width / 1.5, height: UIScreen.main.bounds.height / 2.2)
            VStack {
                
                if camera.isTaken {
                    Button(action: {
                        withAnimation { camera.isTaken.toggle() }
                        DispatchQueue.global(qos: .background).async {
                            self.camera.session.startRunning()
                        }
                    }, label: {
                        Image(systemName: "arrow.triangle.2.circlepath.camera")
                            .foregroundColor(.black)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 10)
                            .background(Color.white)
                            .clipShape(Circle())
                    })
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing)
                }
                
                Spacer()
                if camera.isTaken {
                    Text("Unknown")
                } else {
//                    NavigationLink(destination: {
//                        AbsentSuccessView(isPresented: $isPresented)
//                    }, label: {
//                        AppNavLinkView(title: "Absen")
//                    })
//                    .padding()
//                    .padding(.bottom, 25)
                    if camera.loading {
                        ProgressView(value: Double(camera.perentage) / 100)
                            .background()
                            .padding()
                            .background(.ultraThinMaterial)
                            .overlay {
                                GeometryReader { metric in
                                    Capsule()
                                        .fill(.red)
                                        .frame(width: 10)
                                        .padding(.trailing,  metric.size.width * 0.2)
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                        .padding(.vertical, 5)
                                }
                                
                            }
                    } else {
                        AppButton(title: "Absen", showLoading: $camera.loading, action: {
                            Helpers.shared.analyticsLog(itemID: "Absen", itemName: "Mencoba melakukan absen", contentType: .button)
                            absentAction()
                        })
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .alert(isPresented: $camera.showMessage) {
                if camera.title != "Gagal" {
                    Helpers.shared.analyticsLog(itemID: "Absen", itemName: "User berhasil absen", contentType: .automatic)
                    return Alert(
                        title: Text(camera.title),
                        message: Text(camera.message),
                        dismissButton: .cancel(Text("Kembali"), action: {
                            isPresented = false
                        })
                    )
                } else {
                    Helpers.shared.analyticsLog(itemID: "Absen", itemName: "User gagal absen", contentType: .button)
                    return Alert(
                        title: Text(camera.title),
                        message: Text(camera.message),
                        primaryButton: .cancel(Text("Ulangi")) {
                            Helpers.shared.analyticsLog(itemID: "Absen", itemName: "User mencoba absen setelah gagal", contentType: .button)
                            self.absentAction()
                            camera.session.startRunning()
                        },
                        secondaryButton: .destructive(Text("Kembali")) {
                        isPresented = false
                    })
                }
                
            }
            
        }
        .onAppear {
            camera.check()
            lvm.checkLocationPermission()
            camera.setEvent(event: event)
        }
        .onDisappear {
            camera.dispose()
        }
    }
}

extension AbsentView {
    enum AbsentState {
        case absent_in
        case absent_out
    }
}


struct AbsentView_Previews: PreviewProvider {
    static var previews: some View {
        @State var example = true
        NavigationStack {
            Text("Hai")
//            AbsentView(isPresented: $example)
        }
    }
}
