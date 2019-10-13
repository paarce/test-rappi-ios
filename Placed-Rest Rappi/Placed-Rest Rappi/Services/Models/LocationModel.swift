//
//  LocationModel.swift
//  Placed-Rest Rappi
//
//  Created by Augusto C.P. on 10/12/19.
//  Copyright © 2019 Augusto C.P. All rights reserved.
//

import Foundation

struct LocationModel : Codable {
    
    let address: String?
    let locality: String?
    let city:  String?
    let city_id: Int?
    let latitude: String?
    let longitude: String?
    let zipcode: String?
    let country_id: Int?
    let locality_verbose: String?

}
