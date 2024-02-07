//
//  DetailEventView.swift
//  Absensi
//
//  Created by I putu Rama anadya on 14/09/23.
//

import SwiftUI

struct DetailEventView: View {
    
    @Binding var isPresented: Bool
    var eventID: Int
    
    @ObservedObject private var vm: DetailEventViewModel
    @ObservedObject private var lvm = LocationViewModel()
    
    init(isPresented: Binding<Bool>, eventID: Int) {
        self._isPresented = isPresented
        self.eventID = eventID
        vm = DetailEventViewModel()
        vm.fetchSingleEvent(id: eventID)
        lvm.checkLocationPermission()
    }
    
    var body: some View {
        if vm.loading {
            ProgressView()
        } else {
            ScrollView {
                VStack(spacing: 20) {
                    Text(vm.event?.nama ?? "")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                        .padding(.top, 25)
                        .padding(.horizontal, 8)
                    VStack {
                        HStack {
                            Image(systemName: "mappin.circle.fill")
                                .foregroundColor(Color("primary"))
                            Text(vm.event?.tempat ?? "")
                        }
                        Text("\(lvm.checkUserDistanceWithEvent(lat: vm.event?.lat ?? "0", lon: vm.event?.long ?? "0"))m dari lokasimu")
                            .foregroundColor(.gray)
                            .font(.caption2)
                    }
                    Line()
                        .stroke(style: .init(dash: [1]))
                        .foregroundStyle(.gray)
                        .frame(height: 1)
                    Text(Helpers.shared.dateFormatter(from: vm.event?.tanggal ?? 0))
                        .font(.title3)
                        .fontWeight(.semibold)
                    HStack {
                        Spacer()
                        HStack {
                            Text("Masuk:")
                                .fontWeight(.semibold)
                            Text("\(Helpers.shared.timeFormatter(from: vm.event?.absenMasukMulaiEpoch ?? 0))\n-\n\(Helpers.shared.timeFormatter(from: vm.event?.absenMasukSelesaiEpoch ?? 0))")
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                        }
                        Spacer()
                        HStack {
                            Text("Keluar:")
                                .fontWeight(.semibold)
                            Text("\(Helpers.shared.timeFormatter(from: vm.event?.absenKeluarMulaiEpoch ?? 0))\n-\n\(Helpers.shared.timeFormatter(from: vm.event?.absenKeluarSelesaiEpoch ?? 0))")
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                        }
                        Spacer()
                    }
                    Text("Kuota terpakai")
                    if vm.event?.kuotaTakTerbatas == 1 {
                        Text("∞")
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                    } else {
                        HStack(alignment: .bottom, spacing: 0) {
                            Text("10")
                                .font(.largeTitle)
                                .fontWeight(.heavy)
                            Text("/10")
                                .foregroundColor(.gray)
                        }
                    }
                    Line()
                        .stroke(style: .init(dash: [1]))
                        .foregroundStyle(.gray)
                        .frame(height: 1)
                    Grid {
                        GridRow {
                            VStack {
                                if vm.event?.absenMasukAtEpoch != nil {
                                    Text(Helpers.shared.timeFormatter(from: vm.event?.absenMasukAtEpoch ?? 0))
                                        .padding(.all, 10)
                                        .background(Color.green)
                                        .cornerRadius(50)
                                        .foregroundColor(.white)
                                        .font(.body)
                                        .opacity(1)
                                } else {
                                    Text("0")
                                        .padding(.all, 10)
                                        .background(Color.green)
                                        .cornerRadius(50)
                                        .foregroundColor(.white)
                                        .font(.body)
                                        .opacity(0)
                                }
                                Rectangle()
                                    .fill(vm.canAbsentOUT ? Color.green : Color("not_start"))
                                    .aspectRatio(1, contentMode: .fit)
                                    .overlay {
                                        Image(systemName: "figure.walk.arrival")
                                            .resizable()
                                            .padding(.all, 50)
                                            .foregroundColor(.white)
                                        
                                    }
                                    .cornerRadius(40)
                                    .shadow(color: .green.opacity(0.3), radius: 5, x: -1, y: 5)
                                Text("Absen Masuk")
                                    .fontWeight(.bold)
                            }
                            .onTapGesture {
                                Helpers.shared.analyticsLog(itemID: "DetailEvent", itemName: "Menekan tombol absen masuk", contentType: .button)
                                if !vm.canAbsentIN {
                                    return
                                }
                                vm.absentIN.toggle()
                            }
                            .navigationDestination(isPresented: $vm.absentIN, destination: {
                                AbsentView(isPresented: $isPresented, event: vm.event!, state: .absent_in)
                            })
                            VStack {
                                if vm.event?.absenKeluarAtEpoch != nil {
                                    Text(Helpers.shared.timeFormatter(from: vm.event?.absenKeluarAtEpoch ?? 0))
                                        .padding(.all, 10)
                                        .background(Color.red)
                                        .cornerRadius(50)
                                        .foregroundColor(.white)
                                        .font(.body)
                                        .opacity(1)
                                } else {
                                    Text("0")
                                        .padding(.all, 10)
                                        .background(Color.green)
                                        .cornerRadius(50)
                                        .foregroundColor(.white)
                                        .font(.body)
                                        .opacity(0)
                                }
                                Rectangle()
                                    .fill(vm.canAbsentOUT ? Color.red : Color("not_start"))
                                    .aspectRatio(1, contentMode: .fit)
                                    .overlay {
                                        Image(systemName: "figure.walk.departure")
                                            .resizable()
                                            .padding(.all, 50)
                                            .foregroundColor(.white)
                                            
                                    }
                                    .cornerRadius(40)
                                    .shadow(color: .red.opacity(0.3), radius: 5, x: -1, y: 5)
                                Text("Absen Keluar")
                                    .fontWeight(.bold)
                            }
                            .onTapGesture {
                                Helpers.shared.analyticsLog(itemID: "DetailEvent", itemName: "Menekan tombol absen keluar", contentType: .button)
                                if !vm.canAbsentOUT {
                                    return
                                }
                                vm.absentOUT.toggle()
                            }
                            .navigationDestination(isPresented: $vm.absentOUT, destination: {
                                AbsentView(isPresented: $isPresented, event: vm.event!, state: .absent_out)
                            })
                        }
                    }
                    .padding()
                    
                    
                    NavigationLink(destination: {
                        MapView(annotations: [vm.event!])
                    }, label: {
                        HStack {
                            Image(systemName: "mappin.circle.fill")
                                .foregroundColor(Color("primary"))
                            Text("Lokasi Anda")
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(25)
                        .shadow(color: .gray.opacity(0.2), radius: 5, x: -1, y: 5)
                    })
                    
                }
            }
        }
    }
}

struct DetailEventView_Previews: PreviewProvider {
    static var previews: some View {
        @State var example = false
        DetailEventView(isPresented: $example, eventID: 1)
    }
}

struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        return path
    }
}
