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

class MapRestaurantView: UIView {

    var mapView: MKMapView?
    var parent : HomeViewController?
    
    func iniUI(location : CLLocation, regionRadius : CLLocationDistance, parent : HomeViewController) {
        
        self.parent = parent
        self.backgroundColor = UIColor.green
        self.configMapView()
        self.centerMapOnLocation(location: location, regionRadius: regionRadius)
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
    
    let locationManager = CLLocationManager()
    
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
