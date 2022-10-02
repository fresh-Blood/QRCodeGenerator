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
        view.backgroundColor = #colorLiteral(red: 0.1999788582, green: 0.2000134587, blue: 0.1999712884, alpha: 1)
        setLoadingGif()
        presentQrCodeGenViewController()
    }
    
    private func setLoadingGif() {
        let loadingGif = UIImage.gifImageWithName("ghostLoading")
        gifImageView.image = loadingGif
    }
    
    private func presentQrCodeGenViewController() {
        let qrCodeGenVC = QRCodeGeneratorViewController()
        qrCodeGenVC.modalTransitionStyle = .crossDissolve
        qrCodeGenVC.modalPresentationStyle = .fullScreen
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.7, execute: { [weak self] in
            self?.present(qrCodeGenVC, animated: true, completion: nil)
        })
    }
}
