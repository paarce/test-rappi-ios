//
//  RestaurantDetailViewModel.swift
//  Placed-Rest Rappi
//
//  Created by Augusto C.P. on 10/14/19.
//  Copyright © 2019 Augusto C.P. All rights reserved.
//

import Foundation



class RestaurantDetailViewModel {

    func callDailyMenuObservable(id : String, completation: @escaping (Result<DailyMenuModel,ErrorApi>) -> Void) {
        
        if let idint = Int(id) {
            Api.request(endpoint : .dailyMenu(res_id: idint), completation : completation)
        }
    }
    
}
