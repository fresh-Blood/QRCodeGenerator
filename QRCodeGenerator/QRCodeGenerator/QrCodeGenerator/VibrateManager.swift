//
//  VibrateManager.swift
//  QRCodeGenerator
//
//  Created by Admin on 01.10.2022.
//

import Foundation
import UIKit

struct VibrateManager {
    static let generator = UINotificationFeedbackGenerator()
    
    static func vibrateSuccess() {
        generator.prepare()
        generator.notificationOccurred(.success)
    }
    
    static func vibrateFailure() {
        generator.prepare()
        generator.notificationOccurred(.error)
    }
}
