//
//  MapRestaurantView.swift
//  Placed-Rest Rappi
//
//  Created by Augusto C.P. on 10/13/19.
//  Copyright © 2019 Augusto C.P. All rights reserved.
//

import UIKit
import MapKit
import SnapKit

class MapRestaurantView: UIView, CLLocationManagerDelegate {

    var mapView: MKMapView?
    var parent : HomeViewController?
    
    let locationManager = CLLocationManager()
    let regionRadius: CLLocationDistance = 1000
    var settedLocation = false
    
    func iniUI( parent : HomeViewController) {
        
        self.parent = parent
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        self.configMapView()
    }
    
    func configMapView() {
        
        mapView = MKMapView(frame: self.frame)
        mapView!.delegate = self
        mapView!.register(RestaurantPinView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        self.addSubview(self.mapView!)
        mapView?.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalToSuperview()
        }
        
    }
    
    // MARK: - CLLocationManager
    
    
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedAlways {
            mapView?.showsUserLocation = true
            
        } else {
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    func centerMapOnLocation(location: CLLocation, regionRadius : CLLocationDistance) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView?.setRegion(coordinateRegion, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocation = manager.location else { return }
        
        if !self.settedLocation {
            
            self.parent?.initUser(location: locValue)
            self.centerMapOnLocation(location: locValue, regionRadius: self.regionRadius)
            self.parent?.loadInitialData()
            self.settedLocation = true
            
        }
    }
    

}


// MARK: - MKMapViewDelegate

extension MapRestaurantView: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        
        let pin = view.annotation as! RestaurantPin
        self.parent?.showDetailof(restaurant: pin.data)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }
        
        if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "") {
            annotationView.annotation = annotation
            return annotationView
        } else {
            let annotationView = MKPinAnnotationView(annotation:annotation, reuseIdentifier:"")
            annotationView.isEnabled = true
            annotationView.canShowCallout = true
            
            let btn = UIButton(type: .infoDark)
            annotationView.leftCalloutAccessoryView = btn
            return annotationView
        }
    }
    
}
