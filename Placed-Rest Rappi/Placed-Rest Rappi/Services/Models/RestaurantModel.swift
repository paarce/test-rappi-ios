//
//  RestaurantModel.swift
//  Placed-Rest Rappi
//
//  Created by Augusto C.P. on 10/12/19.
//  Copyright © 2019 Augusto C.P. All rights reserved.
//

import Foundation

struct RestaurantModel : Codable {

    let restaurant: RestaurantChildModel
}

struct RestaurantChildModel : Codable {

    let id: String?
    let name: String?
    let url: String?
    let location: LocationModel
    let photos : [PhotoModel]
}
