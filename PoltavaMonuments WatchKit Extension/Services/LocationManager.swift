//
//  LocationManager.swift
//  PoltavaMonuments WatchKit Extension
//
//  Created by Bohdan Pokhidnia on 17.01.2022.
//

import Foundation
import CoreLocation

protocol LocationManagerDelegate: AnyObject {
    func locationOn()
    func locationOff()
    func locationDidUpdate(location: CLLocation)
}

extension LocationManagerDelegate {
    func locationOn() {}
    func locationOff() {}
    func locationDidUpdate(location: CLLocation) {}
}

final class LocationManager: NSObject {
    
    var updateDistanceHandler: (() -> ())?
    weak var delegate: LocationManagerDelegate?
    let kDistanceThenNeedRefreshLocation = 50
    
    private var locationManager = CLLocationManager()
    
    var currentLocation: CLLocation {
        return locationManager.location ?? CLLocation(latitude: 22.8, longitude: 22.9)
    }
    
    var locationStatus: Bool = false
    
    override init() {
        super.init()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.activityType = .airborne
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
//        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.distanceFilter = CLLocationDistance(kDistanceThenNeedRefreshLocation)
        locationManager.requestAlwaysAuthorization()
        locationManager.requestLocation()
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        
        delegate?.locationDidUpdate(location: newLocation)
        updateDistanceHandler?()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            locationStatus = true
            delegate?.locationOn()
            locationManager.startUpdatingLocation()
            
        case .notDetermined:
            break
        
        default:
            locationStatus = false
            delegate?.locationOff()
        }
    }
    
}
