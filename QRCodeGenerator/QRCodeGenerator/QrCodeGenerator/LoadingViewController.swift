//
//  LoadingViewController.swift
//  QRCodeGenerator
//
//  Created by Admin on 01.10.2022.
//

import UIKit

final class LoadingViewController: UIViewController {
    
    @IBOutlet weak var gifImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoadingImageView()
        gifImageView.alpha = .zero
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.3,
                       delay: .zero,
                       options: .curveEaseInOut,
                       animations: {
            self.gifImageView.alpha = 1.0
        }, completion: { [weak self] finished in
            if finished {
                self?.presentQrCodeGenViewController()
            }
        })
    }
    
    private func setupLoadingImageView() {
        let loadingGif = UIImage.gifImageWithName("ghostLoading")
        gifImageView.image = loadingGif
    }
    
    private func presentQrCodeGenViewController() {
        let qrCodeGenVC = QRCodeGeneratorViewController()
        qrCodeGenVC.modalTransitionStyle = .crossDissolve
        qrCodeGenVC.modalPresentationStyle = .fullScreen
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.4, execute: { [weak self] in
            self?.present(qrCodeGenVC, animated: true, completion: nil)
        })
    }
}
