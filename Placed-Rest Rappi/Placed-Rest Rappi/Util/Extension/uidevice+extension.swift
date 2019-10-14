//
//  uidevice+extension.swift
//  Placed-Rest Rappi
//
//  Created by Augusto C.P. on 10/14/19.
//  Copyright © 2019 Augusto C.P. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

extension UIDevice {
    static func vibrate() {
        let peek = SystemSoundID(1519)
        AudioServicesPlaySystemSound(peek)
    }
}
