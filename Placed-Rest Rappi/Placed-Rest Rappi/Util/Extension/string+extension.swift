//
//  string+extension.swift
//  Placed-Rest Rappi
//
//  Created by Augusto C.P. on 10/14/19.
//  Copyright © 2019 Augusto C.P. All rights reserved.
//

import Foundation


extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    var numberFormat : String {
        
        let r1 = self.replacingOccurrences(of: "(", with: "")
        let r2 = r1.replacingOccurrences(of: ")", with: "")
        let r3 = r2.replacingOccurrences(of: " ", with: "")
        
        return r3.replacingOccurrences(of: "-", with: "")
        
    }
}
