//
//  ViewController.swift
//  QRGenerator
//
//  Created by Admin on 27.09.2022.
//

import UIKit

final class QRCodeGeneratorViewController: UIViewController {
    
    struct Layout {
        let contentInsets: UIEdgeInsets
        static var `default`: Layout {
            Layout(contentInsets: UIEdgeInsets(top: Constants.topInset,
                                               left: Constants.leftInset,
                                               bottom: Constants.bottomInset,
                                               right: Constants.rightInset))
        }
    }
    
    private lazy var layout: Layout = .default
    
    private lazy var textInput: UITextField = {
        let textInput = UITextField()
        textInput.translatesAutoresizingMaskIntoConstraints = false
        textInput.placeholder = Constants.textInputPlaceHolder
        textInput.font = .preferredFont(forTextStyle: .body, compatibleWith: .none)
        textInput.borderStyle = .roundedRect
        textInput.clearButtonMode = .whileEditing
        return textInput
    }()
    
    private lazy var generateQRCodeButton: UIButton = {
        let button = UIButton()
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = Constants.generateQRCodeButtonLayerBorderWidth
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Constants.generateQRCodeButtonTitle, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(generateQRCode), for: .touchUpInside)
        return button
    }()
    
    private lazy var loaderView: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView()
        loader.hidesWhenStopped = true
        loader.style = .medium
        loader.translatesAutoresizingMaskIntoConstraints = false
        return loader
    }()
    
    private lazy var qrCodeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    @objc
    private func generateQRCode() {
        guard let textToGenerateQRCode = textInput.text,
              !textToGenerateQRCode.isEmpty else { return }
        loaderView.startAnimating()
        let data = textToGenerateQRCode.data(using: .ascii)
        if let qrFilter = CIFilter(name: "CIQRCodeGenerator") {
            qrFilter.setValue(data, forKey: "inputMessage")
            if let qrImage = qrFilter.outputImage {
                let transform = CGAffineTransform(scaleX: 10, y: 10)
                let scaledQrImage = qrImage.transformed(by: transform)
                let context = CIContext()
                guard let cgImage = context.createCGImage(scaledQrImage, from: scaledQrImage.extent) else { return }
                loaderView.stopAnimating()
                qrCodeImage.image = UIImage(cgImage: cgImage)
                generateQRCodeButton.removeTarget(self, action: #selector(generateQRCode), for: .touchUpInside)
                generateQRCodeButton.setTitle(Constants.shareTitle, for: .normal)
                generateQRCodeButton.addTarget(self, action: #selector(share), for: .touchUpInside)
            }
        }
    }
    
    @objc
    private func share() {
        guard let qrCodeImage = qrCodeImage.image else { return }
        let imageToShare = [ qrCodeImage ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = view
        present(activityViewController, animated: true, completion: { [weak self] in
            self?.returnInitialGenerateQRCodeButtonBehavior()
        })
        textInput.text?.removeAll()
    }
    
    private func returnInitialGenerateQRCodeButtonBehavior() {
        generateQRCodeButton.removeTarget(self, action: #selector(share), for: .touchUpInside)
        generateQRCodeButton.setTitle(Constants.generateQRCodeButtonTitle, for: .normal)
        generateQRCodeButton.addTarget(self, action: #selector(generateQRCode), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        textInput.delegate = self
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(textInput)
        view.addSubview(generateQRCodeButton)
        qrCodeImage.addSubview(loaderView)
        view.addSubview(qrCodeImage)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            textInput.topAnchor.constraint(equalTo: view.topAnchor, constant: layout.contentInsets.top),
            textInput.leftAnchor.constraint(equalTo: view.leftAnchor, constant: layout.contentInsets.left),
            textInput.rightAnchor.constraint(equalTo: view.rightAnchor, constant: layout.contentInsets.right),
            generateQRCodeButton.topAnchor.constraint(equalTo: textInput.bottomAnchor, constant: 16),
            generateQRCodeButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: layout.contentInsets.left),
            generateQRCodeButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: layout.contentInsets.right),
            qrCodeImage.topAnchor.constraint(equalTo: generateQRCodeButton.bottomAnchor, constant: 50),
            qrCodeImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: layout.contentInsets.left),
            qrCodeImage.rightAnchor.constraint(equalTo: view.rightAnchor, constant: layout.contentInsets.right),
            qrCodeImage.heightAnchor.constraint(equalToConstant: 300),
            loaderView.centerXAnchor.constraint(equalTo: qrCodeImage.centerXAnchor),
            loaderView.centerYAnchor.constraint(equalTo: qrCodeImage.centerYAnchor)
        ])
    }
}

extension QRCodeGeneratorViewController: UITextFieldDelegate {

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if var text = textField.text {
            text.removeAll()
        }
        qrCodeImage.image = nil 
        returnInitialGenerateQRCodeButtonBehavior()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
}

private enum Constants {
    static let textInputPlaceHolder: String = "Type/Copy/Paste your text/link"
    static let generateQRCodeButtonTitle: String = "Generate"
    static let shareTitle: String = "Share"
    static let generateQRCodeButtonLayerBorderWidth: CGFloat = 2
    static let cornerRadius: CGFloat = 2.0
    static let topInset: CGFloat = 200
    static let leftInset: CGFloat = 20
    static let rightInset: CGFloat = -20
    static let bottomInset: CGFloat = -40
}
