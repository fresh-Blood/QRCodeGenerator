//
//  UIViewController+Extension.swift
//  QRCodeGenerator
//
//  Created by Admin on 02.10.2022.
//

import Foundation
import UIKit

extension UIViewController {
    func prepairForIPad(withVCView: UIView?, withVC: UIViewController?) {
        self.popoverPresentationController?.sourceView = withVCView
        self.popoverPresentationController?.sourceRect = CGRect(origin: withVCView?.center ?? .zero, size: .zero)
        self.popoverPresentationController?.barButtonItem = withVC?.navigationItem.backBarButtonItem
    }
}
