//
//  UIColor+Extension.swift
//  QRCodeGenerator
//
//  Created by Admin on 01.10.2022.
//

import Foundation
import UIKit

extension UIColor {
    static func random() -> UIColor {
        return UIColor(
           red:   .random(),
           green: .random(),
           blue:  .random(),
           alpha: 1.0
        )
    }
}
