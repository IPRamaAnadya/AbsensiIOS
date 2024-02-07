//
//  FaceRegister.swift
//  Absensi
//
//  Created by I putu Rama anadya on 03/10/23.
//

import SwiftUI

struct FaceRegisterView: View {
    
    @ObservedObject private var vm = FaceRegisterViewmodel()
    
    var body: some View {
        ZStack {
            CameraPreview2(camera: vm)
//            Color.black
                .ignoresSafeArea()
            
            if !vm.taken {
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
                AppButton(title: "Ambil gambar", showLoading: $vm.taken, action: {vm.takePicture()})
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .padding()
            } else {
                VStack {
                    Spacer()
                    HStack(alignment: .center){
                        if !vm.loading {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.red)
                                .frame(height: 50)
                                .overlay{
                                    Text("Ulangi")
                                        .foregroundColor(.white)
                                }
                                .onTapGesture {
                                    Helpers.shared.analyticsLog(itemID: "Face Register", itemName: "Mengambil foto ulang", contentType: .button)
                                    vm.taken.toggle()
                                    DispatchQueue.global(qos: .background).async {
                                        vm.session.startRunning()
                                    }
                                }
                        }
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.green)
                            .frame(height: 50)
                            .overlay{
                                if !vm.loading {
                                    Text("Daftarkan Wajah")
                                        .foregroundColor(.white)
                                } else {
                                    ProgressView()
                                }
                            }
                            .onTapGesture {
                                Helpers.shared.analyticsLog(itemID: "Face Register", itemName: "Mendaftarkan Wajah", contentType: .button)
                                vm.register()
                            }
                    }
                    .padding(.horizontal,20)
                    
                .padding()
                }
            }
        }
        .onAppear {
            Helpers.shared.analyticsLog(itemID: "Face Register", itemName: "Berada di halaman registrasi wajah", contentType: .automatic)
            vm.check()
        }
        .alert(isPresented: $vm.showMessage, content: {
            Alert(title: Text(vm.title),
                  message: Text(vm.message),
                  dismissButton: .destructive(Text("Kembali"), action: {
                if vm.title == "Berhasil" {
                    Helpers.shared.analyticsLog(itemID: "Face Register", itemName: "Register wajah berhasil", contentType: .automatic)
                    vm.gotToDashboard.toggle()
                }
            })
            )
        })
        .navigationDestination(isPresented: $vm.gotToDashboard, destination: {
            DashboardView()
                .navigationBarHidden(true)
        })
    }
}

#Preview {
    FaceRegisterView()
}
