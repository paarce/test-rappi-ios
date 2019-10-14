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
    
    var searchLocation : CLLocation
    var itemPerPage = 20
    var pageNumber = 1
    var currentSort = ""
    
    init() {
        self.searchLocation = CLLocation(latitude: defaultCoordinate["latitude"]!, longitude: defaultCoordinate["longitude"]!)
    }
    
    func callSearchObservable(query : String? = nil, completation: @escaping (Result<SearchModel,ErrorApi>) -> Void) {
        self.pageNumber = 1
        Api.request(endpoint : .search(lat: self.searchLocation.coordinate.latitude ,
                                        log: self.searchLocation.coordinate.longitude,
                                        q: query,
                                        start : nil,
                                        sort : self.currentSort),
                    completation : completation)
    }
    
    
    func callSearchObservable( sort : String, completation: @escaping (Result<SearchModel,ErrorApi>) -> Void) {
        self.currentSort = sort
        Api.request(endpoint : .search(lat: self.searchLocation.coordinate.latitude ,
                                       log: self.searchLocation.coordinate.longitude,
                                       q: nil,
                                       start : self.pageNumber*itemPerPage,
                                       sort : self.currentSort ),
                    completation : completation)
    }
    
    func callSearchNextPageObservable( completation: @escaping (Result<SearchModel,ErrorApi>) -> Void) {
        
        Api.request(endpoint : .search(lat: self.searchLocation.coordinate.latitude ,
                                       log: self.searchLocation.coordinate.longitude,
                                       q: nil,
                                       start : self.pageNumber*itemPerPage,
                                       sort : self.currentSort ),
                    completation : completation)
    }
    
    
}
