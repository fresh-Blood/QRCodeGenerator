//
//  Constants.swift
//  QRCodeGenerator
//
//  Created by Admin on 01.10.2022.
//

import Foundation
import UIKit

enum Constants {
    static let textInputPlaceHolder: String = "Введите или вставьте ваш текст"
    static let generateQRCodeButtonTitle: String = "Создать QR"
    static let shareTitle: String = "Поделиться"
    static let cornerRadius: CGFloat = 16.0
    static let textInputTopAnchorValue: CGFloat = 16
    static let topInset: CGFloat = 20 + (UIApplication.shared.keyWindow?.safeAreaInsets.top ?? .zero)
    static let leftInset: CGFloat = 20
    static let rightInset: CGFloat = -20
    static let bottomInset: CGFloat = -40
    static let generateQRCodeButtonWidth: CGFloat = 150
    static let generateQRCodeButtonHeight: CGFloat = 70
    static let padding: UIEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    static let loadingAnimationDuration: CGFloat = 2.6
    static let shadowAnimationDuration: CGFloat = 1.5
    static let generateQRCodeButtonTopAnchorValue: CGFloat = 50.0
    static let textInputHeightAnchorValue: CGFloat = 50.0
    static let gifImageViewHeightAnchorValue: CGFloat = 300.0
}
