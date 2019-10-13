//
//  Const.swift
//  Placed-Rest Rappi
//
//  Created by Augusto C.P. on 10/12/19.
//  Copyright © 2019 Augusto C.P. All rights reserved.
//

import Foundation
import RxSwift

let deviceUID = UIDevice.current.identifierForVendor!.uuidString
let disposbag = DisposeBag()
let defaults = UserDefaults.standard
let defaultCoordinate : [String : Double] = ["latitude": 40.781963, "longitude": -73.966385]
//let defaultCoordinate : [String : Double] = ["latitude": 13.5596259996, "longitude": 78.4987232834]

