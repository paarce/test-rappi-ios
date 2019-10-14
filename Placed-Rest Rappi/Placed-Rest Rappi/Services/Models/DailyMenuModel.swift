//
//  DailyMenuModel.swift
//  Placed-Rest Rappi
//
//  Created by Augusto C.P. on 10/14/19.
//  Copyright © 2019 Augusto C.P. All rights reserved.
//

import Foundation

struct DailyMenuModel : Codable {
    
    let daily_menu: [DailyMenuChildModel]
}

struct DailyMenuChildModel : Codable {
    
    let daily_menu_id: String?
    let name: String?
    let start_date: String?
    let dishes : [DishModel]?
}


struct DishModel : Codable {
    
    let dish_id: String?
    let name: String?
    let price: String?
}
