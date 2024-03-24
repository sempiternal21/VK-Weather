//
//  LocationManager.swift
//  VK-WeatherApp
//
//  Created by Danil Antonov on 19.03.2024.
//

import Foundation
import CoreLocation

final class LocationManager: NSObject, CLLocationManagerDelegate {
    
    static let shared = LocationManager()
    
    private let manager = CLLocationManager()
    
    private var locationFetchCompletion: ((CLLocation) -> Void)?
    
    private var location: CLLocation? {
        didSet {
            guard let location else {
                return
            }
            locationFetchCompletion?(location)
        }
    }
    
    public func getCurrentLocation(completion: @escaping (CLLocation) -> Void) {
        self.locationFetchCompletion = completion
        manager.requestWhenInUseAuthorization()
        manager.delegate = self
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        self.location = location
        manager.stopUpdatingLocation()
    }
    
    func haveAccessToLocation() -> Bool {
        switch manager.authorizationStatus {
            case .restricted, .denied:
                return false
            case .authorizedAlways, .notDetermined, .authorizedWhenInUse:
                return true
            @unknown default:
                return true
        }
    }
}
