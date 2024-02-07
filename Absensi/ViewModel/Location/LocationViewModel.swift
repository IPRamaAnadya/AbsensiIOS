//
//  LocationViewModel.swift
//  Absensi
//
//  Created by I putu Rama anadya on 27/09/23.
//

import SwiftUI
import CoreLocation
import MapKit

class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var locationManager: CLLocationManager?
    
    var eventLocation: CLLocationCoordinate2D?
    
    @Published var userLocation: CLLocation?
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -8.409518, longitude: 115.188919),
        span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    
    override init() {
        super.init()
        self.locationManager = CLLocationManager()
        self.locationManager?.delegate = self
        self.locationManager?.requestWhenInUseAuthorization()
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.locationManager?.startUpdatingLocation()
    }
    
    @MainActor
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        userLocation = location
        
        if let eventLoc = self.eventLocation {
            region = regionBetweenLocations(from: [
                CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude),
                eventLoc
            ])
        } else {
            region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        }
    }
    
    @MainActor
    func requestLocation() {
        locationManager?.requestLocation()
    }
    
    @MainActor
    func checkLocationPermission() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            print("Location permission status: Not Determined")
        case .restricted:
            print("Location permission status: Restricted")
        case .denied:
            print("Location permission status: Denied")
        case .authorizedWhenInUse:
            print("Location permission status: Authorized When In Use")
            locationManager?.requestLocation()
        case .authorizedAlways:
            print("Location permission status: Authorized Always")
            locationManager?.requestLocation()
        @unknown default:
            print("Unknown location permission status")
        }
    }
    
    @MainActor
    func checkUserDistanceWithEvent(lat: String, lon: String) -> String {
        
        guard let lat = Double(lat), let lon = Double(lon) else {
            print("Gagal menghitung jarak")
            return "-"
        }
        
        let locationToCompare = CLLocation(latitude: lat, longitude: lon) 
        let distanceInMeters = userLocation?.distance(from: locationToCompare)
        
        return Int(distanceInMeters ?? 0).description
    }
    
    @MainActor
    func checkUserInRadius(lat: String, lon: String, radius: Int) -> Bool {
        
        guard let lat = Double(lat), let lon = Double(lon) else {
            print("Gagal menghitung jarak")
            return false
        }
        let locationToCompare = CLLocation(latitude: lat, longitude: lon)
        let distanceInMeters = userLocation?.distance(from: locationToCompare)
        
        print(Int(distanceInMeters ?? 0))
        
        return Int(distanceInMeters ?? 0) <= radius
    }
    
    @MainActor
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    @MainActor
    func regionBetweenLocations(from coordinates: [CLLocationCoordinate2D]) -> MKCoordinateRegion {
      let latitudes = coordinates.map { $0.latitude }
      let longitudes = coordinates.map { $0.longitude }

      let minLat = latitudes.min()!
      let maxLat = latitudes.max()!
      let minLon = longitudes.min()!
      let maxLon = longitudes.max()!

      let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2, longitude: (minLon + maxLon) / 2)
      let span = MKCoordinateSpan(latitudeDelta: maxLat - minLat, longitudeDelta: maxLon - minLon)

      return MKCoordinateRegion(center: center, span: span)
    }
}
