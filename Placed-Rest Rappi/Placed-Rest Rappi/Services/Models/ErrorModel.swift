//
//  ErrorModel.swift
//  Placed-Rest Rappi
//
//  Created by Augusto C.P. on 10/12/19.
//  Copyright © 2019 Augusto C.P. All rights reserved.
//

import Foundation


enum ErrorApi : Error {
    case Error(ErrorModel)
    
    func get() -> ErrorModel {
        switch self {
        case .Error(let model):
            return model
        }
    }
}


struct ErrorModel:Codable{
    let statusCode : Int?
    let message : String?
    
    enum ErrorModel : String, CodingKey {
        case statusCode
        case message
    }
    
}
