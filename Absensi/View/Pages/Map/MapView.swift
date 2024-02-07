//
//  MapView.swift
//  Absensi
//
//  Created by I putu Rama anadya on 14/09/23.
//

import SwiftUI
import MapKit

struct City: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}


struct MapView: View {
    
    @ObservedObject var location = LocationViewModel()
    
    let annotations: [EventEntity]
    
    init(annotations: [EventEntity]) {
        self.annotations = annotations
    }
    
    
    var body: some View {
        Map(coordinateRegion: $location.region, showsUserLocation: true, annotationItems: annotations) {
//            MapMarker(coordinate: $0.coordinate)
            MapAnnotation(
                coordinate: CLLocationCoordinate2D(
                    latitude: Double($0.lat ?? "0")!,
                    longitude: Double($0.long ?? "0")!)) {
                        VStack {
                            Text("Lokasi acara\n\(location.checkUserDistanceWithEvent(lat: (annotations.first?.lat ?? "0"), lon: (annotations.first?.long ?? "0")))m dari lokasimu")
                                .font(.caption)
                                .shadow(color: .white, radius: 1)
                                .multilineTextAlignment(.center)
                            Image(systemName: "mappin")
                                .foregroundColor(Color.red)
                                .frame(width: 20, height: 20)
                        }
                
            }
            
//            MKCircle(center: $0.coordinate, radius: 2000)
        }
            .navigationTitle("Lokasi saat ini")
            .onAppear {
                Helpers.shared.analyticsLog(itemID: "About", itemName: "berada di halaman Map", contentType: .automatic)
                location.eventLocation = CLLocationCoordinate2D(
                    latitude: Double(annotations.first?.lat ?? "0")!,
                    longitude: Double(annotations.first?.long ?? "0")!
                )
            }
            .onDisappear {
                Helpers.shared.analyticsLog(itemID: "About", itemName: "keluar dari halaman Map", contentType: .automatic)
            }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(annotations: [EventEntity(id: nil, nama: nil, deskripsi: nil, tempat: nil, lat: nil, long: nil, radius: nil, tanggalEpoch: nil, absenMasukMulaiEpoch: nil, absenMasukSelesaiEpoch: nil, absenKeluarMulaiEpoch: nil, absenKeluarSelesaiEpoch: nil, status: nil, tanggal: nil, kuotaTerpakai: nil, kuotaTersisa: nil, totalKuota: nil, kuotaTakTerbatas: nil, absenMasukAtEpoch: nil, absenKeluarAtEpoch: nil)])
    }
}
