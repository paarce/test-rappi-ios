//
//  ReviewModel.swift
//  Placed-Rest Rappi
//
//  Created by Augusto C.P. on 10/14/19.
//  Copyright © 2019 Augusto C.P. All rights reserved.
//

import Foundation


struct ReviewsListModel : Codable {
    
    let reviews : [ReviewModel]?
}

struct ReviewModel : Codable {
    let review : ReviewChildModel
}


struct ReviewChildModel : Codable {
    
    let id: Int?
    let rating: Float?
    let rating_text: String?
    let rating_color: String?
    let user : UserChildModel?
}

