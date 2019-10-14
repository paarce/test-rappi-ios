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
    let phone_numbers : String?
    let thumb : String?
    let location: LocationModel?
    let photos : [PhotoModel]?
    let all_reviews : ReviewsListModel?
    let user_rating : UserRatingModel?
}

struct UserRatingModel : Codable {

    var aggregate_rating: Any
    let rating_text: String?
    let rating_color: String?
    var votes: Any
    
    
    init(aggregate_rating: Any, rating_text: String?,  rating_color: String?, votes: Any) {
        self.aggregate_rating = aggregate_rating
        self.rating_text = rating_text
        self.rating_color = rating_color
        self.votes = votes
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        self.aggregate_rating = "0.0"
        self.votes = "0"
        
        if let idstr = try? container.decodeIfPresent(String.self, forKey: .aggregate_rating) {
            if let idnum = Int(idstr) {
                aggregate_rating = idnum
            }
            else {
                aggregate_rating = idstr
            }
        }else if let idnum = try? container.decodeIfPresent(Int.self, forKey: .aggregate_rating) {
            
            votes = idnum
        }
        
        if let idstr = try? container.decodeIfPresent(String.self, forKey: .votes) {
            if let idnum = Int(idstr) {
                votes = idnum
            }
            else {
                votes = idstr
            }
        }else if let idnum = try? container.decodeIfPresent(Int.self, forKey: .votes) {
            
            votes = idnum
        }
        
        
        self.rating_text = try container.decodeIfPresent(String.self, forKey: .rating_text)
        self.rating_color = try container.decodeIfPresent(String.self, forKey: .rating_color)
        
        return
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        try container.encode(String(describing: aggregate_rating), forKey: .aggregate_rating)
    }
    
    enum Keys: String, CodingKey {
        case aggregate_rating
        case rating_text
        case rating_color
        case votes
        
    }
    
    
    
}

enum AggregateRatingValue: Codable {
    init(from decoder: Decoder) throws {
        
        if let int = try? decoder.singleValueContainer().decode(Int.self) {
            self = .int(value: int)
            return
        }
        
        if let string = try? decoder.singleValueContainer().decode(String.self) {
            self = .string(name: string)
            return
        }
        
        throw  DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Could not serialise"))
    }
    
    func encode(to encoder: Encoder) throws {
        
    }
    
    case int(value: Int)
    case string(name: String)
}
