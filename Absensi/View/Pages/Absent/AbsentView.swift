//
//  AbsentView.swift
//  Absensi
//
//  Created by I putu Rama anadya on 15/09/23.
//

import SwiftUI
import AVFoundation

struct AbsentView: View {
    
    @StateObject var camera =  CameraModel()
    @Binding var isPresented: Bool
    @State var showAlert = false
    
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
                    
                    Button(action: camera.savePicture, label: {
                        Text("Save")
                            .foregroundColor(.black)
                            .fontWeight(.semibold)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .background(Color.white)
                            .clipShape(Capsule())
                    })
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                    
                } else {
//                    NavigationLink(destination: {
//                        AbsentSuccessView(isPresented: $isPresented)
//                    }, label: {
//                        AppNavLinkView(title: "Absen")
//                    })
//                    .padding()
//                    .padding(.bottom, 25)
//                    AppButton(title: "Absen", action: {showAlert.toggle()})
//                        .padding()
//                        .padding(.bottom, 25)
//                    .frame(maxWidth: .infinity)
//                    .alert(isPresented: $showAlert) {
//                        Alert(
//                            title: Text("Absen Gagal"),
//                            message: Text("Wajah anda kurang good looking"),
//                            primaryButton: .cancel(Text("Ulangi")) {
//                                print("Ulangi")
//                            },
//                            secondaryButton: .destructive(Text("Kembali")) {
//                            isPresented = false
//                        })
//                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
        }
        .navigationTitle("Absen")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            camera.check()
        }
    }
}


struct AbsentView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Test")
//        NavigationStack {
//            AbsentView(isPresented: $example)
//        }
    }
}
