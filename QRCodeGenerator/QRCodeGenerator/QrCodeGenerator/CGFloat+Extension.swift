//
//  CGFloat+Extension.swift
//  QRCodeGenerator
//
//  Created by Admin on 01.10.2022.
//

import Foundation
import UIKit

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}
