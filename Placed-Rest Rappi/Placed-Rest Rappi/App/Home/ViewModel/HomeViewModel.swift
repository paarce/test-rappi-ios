//
//  HomeViewModel.swift
//  Placed-Rest Rappi
//
//  Created by Augusto C.P. on 10/12/19.
//  Copyright © 2019 Augusto C.P. All rights reserved.
//

import Foundation
import MapKit
import RxSwift
import RxCocoa

public class HomeViewModel {
    
    let regionRadius: CLLocationDistance = 1000
    var searchLocation : CLLocation
    var itemPerPage = 20
    var pageNumber = 1
    
    init() {
        self.searchLocation = CLLocation(latitude: defaultCoordinate["latitude"]!, longitude: defaultCoordinate["longitude"]!)
    }
    
    func callSearchObservable(query : String? = nil, completation: @escaping (Result<SearchModel,ErrorApi>) -> Void) {
        
        Api.request(endpoint : .search(lat: self.searchLocation.coordinate.latitude ,
                                        log: self.searchLocation.coordinate.longitude,
                                        q: query ),
                    completation : completation)
    }
    
}
