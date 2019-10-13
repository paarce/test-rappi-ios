//
//  PhotoModel.swift
//  Placed-Rest Rappi
//
//  Created by Augusto C.P. on 10/13/19.
//  Copyright © 2019 Augusto C.P. All rights reserved.
//

import Foundation

struct PhotoModel : Codable {
    
    let photo : PhotoChildModel
}


struct PhotoChildModel : Codable {
        
    let id: String?
    let url: String?
    let thumb_url: String?
    let caption: String?
}
