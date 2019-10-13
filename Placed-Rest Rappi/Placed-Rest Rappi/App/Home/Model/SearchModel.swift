//
//  SearchModel.swift
//  Placed-Rest Rappi
//
//  Created by Augusto C.P. on 10/12/19.
//  Copyright © 2019 Augusto C.P. All rights reserved.
//

import Foundation


struct SearchModel : Codable {
    
    let results_found: Int?
    let results_start: Int?
    let results_shown: Int?
    let restaurants : [RestaurantModel]?
    
}
