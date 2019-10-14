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
    let cuisines: String?
    let location: LocationModel
    let photos : [PhotoModel]
    let all_reviews : ReviewsListModel?
    let user_rating : UserRatingModel?
}

struct UserRatingModel : Codable {

    let aggregate_rating: String?
    let rating_text: String?
    let rating_color: String?
    let votes: String?
}

