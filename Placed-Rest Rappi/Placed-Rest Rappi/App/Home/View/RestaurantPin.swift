//
//  RestAnnotation.swift
//  Placed-Rest Rappi
//
//  Created by Augusto C.P. on 10/12/19.
//  Copyright © 2019 Augusto C.P. All rights reserved.
//

import Foundation
import MapKit
import Contacts

class RestaurantPin: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var data : RestaurantModel
    
    init(data: RestaurantModel) {
        self.data = data
        if let la = data.restaurant.location.latitude, let dLa = Double(la),
           let lo = data.restaurant.location.longitude, let dLo = Double(lo) {
            self.coordinate = CLLocationCoordinate2D(latitude: dLa, longitude: dLo)
        }else{
            
            self.coordinate = CLLocationCoordinate2D(latitude: defaultCoordinate["latitude"]!, longitude: defaultCoordinate["longitude"]!)
        }
    }
    
    var title: String? {
        return data.restaurant.name ?? "No title"
    }
    
    var subtitle: String? {
        return data.restaurant.location.address ?? "No address"
    }
    
    // pinTintColor for disciplines: Sculpture, Plaque, Mural, Monument, other
    var markerTintColor: UIColor  {
        return .green
        
    }
    
    var imageName: String? {
        
        return "Flag"
    }
    
    // Annotation right callout accessory opens this mapItem in Maps app
    func mapItem() -> MKMapItem {
        let addressDict = [CNPostalAddressStreetKey: subtitle!]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = data.restaurant.name ?? "No title"
        return mapItem
    }
    
}


class RestaurantPinView: MKAnnotationView {
    
    override var annotation: MKAnnotation? {
        willSet {
            guard let modelPin = newValue as? RestaurantPin else {return}
            
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            let mapsButton = UIButton(frame: CGRect(origin: CGPoint.zero,
                                                    size: CGSize(width: 30, height: 30)))
            mapsButton.setBackgroundImage(UIImage(named: "Maps-icon"), for: UIControl.State())
            rightCalloutAccessoryView = mapsButton
            
            image = UIImage(named: "Flag")
            
//            let detailLabel = UILabel()
//            detailLabel.numberOfLines = 0
//            detailLabel.font = detailLabel.font.withSize(12)
//            detailLabel.text = modelPin.subtitle
//            detailCalloutAccessoryView = detailView
        }
    }
}
