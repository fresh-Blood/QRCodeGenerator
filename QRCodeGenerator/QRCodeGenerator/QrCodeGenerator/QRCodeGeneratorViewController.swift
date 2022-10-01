//
//  QRCodeGeneratorViewController.swift
//  QRCodeGenerator
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
    
    private lazy var gifImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var textInput: TextFieldWithPadding = {
        let textInput = TextFieldWithPadding(with: Constants.padding)
        textInput.translatesAutoresizingMaskIntoConstraints = false
        textInput.placeholder = Constants.textInputPlaceHolder
        textInput.font = .preferredFont(forTextStyle: .body, compatibleWith: .none)
        textInput.backgroundColor = .black
        textInput.clearButtonMode = .whileEditing
        textInput.keyboardAppearance = .dark
        return textInput
    }()
    
    private lazy var generateQRCodeButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Constants.generateQRCodeButtonTitle, for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .headline, compatibleWith: .current)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(generateQRCode), for: .touchUpInside)
        return button
    }()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textInput.delegate = self
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textInput.layer.cornerRadius = 16
    }
    
    private func setupUI() {
        view.backgroundColor = .systemPurple
        view.addSubview(gifImageView)
        view.addSubview(textInput)
        view.addSubview(generateQRCodeButton)
        setupConstraints()
        setInitialGif()
    }
    
    // MARK: - GenerateQRCode
    @objc
    private func generateQRCode() {
        guard let textToGenerateQRCode = textInput.text,
              !textToGenerateQRCode.isEmpty else { return }
        view.endEditing(true)
        animateButton()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { [weak self] in
            self?.generate(with: textToGenerateQRCode)
        })
    }
    
    private func generate(with text: String) {
        let data = text.data(using: .utf8)
        if let qrFilter = CIFilter(name: "CIQRCodeGenerator") {
            qrFilter.setValue(data, forKey: "inputMessage")
            if let qrImage = qrFilter.outputImage {
                let transform = CGAffineTransform(scaleX: 10, y: 10)
                let scaledQrImage = qrImage.transformed(by: transform)
                let context = CIContext()
                guard let cgImage = context.createCGImage(scaledQrImage, from: scaledQrImage.extent) else { return }
                handleFound(cgImage)
            } else {
                configureErrorBehavior()
            }
        }
    }
    
    private func animateButton() {
        VibrateManager.vibrateSoft()
        UIView.animate(withDuration: 0.2,
                       delay: .zero,
                       usingSpringWithDamping: 0.1,
                       initialSpringVelocity: 0.5,
                       options: .curveEaseIn,
                       animations: {
            self.generateQRCodeButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        },
                       completion: { _ in
            UIView.animate(withDuration: 0.2,
                           delay: .zero,
                           usingSpringWithDamping: 0.1,
                           initialSpringVelocity: 0.5,
                           options: .curveEaseOut,
                           animations: {
                self.generateQRCodeButton.transform = CGAffineTransform.identity
            })
        })
    }
    
    private func handleFound(_ cgImage: CGImage) {
        VibrateManager.vibrateSuccess()
        gifImageView.contentMode = .scaleAspectFit
        gifImageView.image = UIImage(cgImage: cgImage)
        setShareQRCodeButtonBehavior()
    }
    
    private func configureErrorBehavior() {
        setErrorGif()
        VibrateManager.vibrateFailure()
    }
    
    // MARK: - Share
    @objc
    private func share() {
        guard let qrCodeImage = gifImageView.image else { return }
        animateButton()
        setSuccessQRGenerateGif()
        let imageToShare = [ qrCodeImage ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = view
        present(activityViewController, animated: true, completion: { [weak self] in
            self?.configureShareCompletion()
        })
    }
    
    private func configureShareCompletion() {
        returnInitialGenerateQRCodeButtonBehavior()
        textInput.text?.removeAll()
        gifImageView.contentMode = .scaleAspectFill
        setInitialGif()
    }
    
    private func setShareQRCodeButtonBehavior() {
        generateQRCodeButton.removeTarget(self, action: #selector(generateQRCode), for: .touchUpInside)
        generateQRCodeButton.setTitle(Constants.shareTitle, for: .normal)
        generateQRCodeButton.addTarget(self, action: #selector(share), for: .touchUpInside)
    }
    
    private func returnInitialGenerateQRCodeButtonBehavior() {
        generateQRCodeButton.removeTarget(self, action: #selector(share), for: .touchUpInside)
        generateQRCodeButton.setTitle(Constants.generateQRCodeButtonTitle, for: .normal)
        generateQRCodeButton.addTarget(self, action: #selector(generateQRCode), for: .touchUpInside)
    }
    
    private func setInitialGif() {
        let initialGif = UIImage.gifImageWithName("ghostInitial")
        gifImageView.image = initialGif
    }
    
    private func setErrorGif() {
        let errorGif = UIImage.gifImageWithName("ghostError")
        gifImageView.image = errorGif
    }
    
    private func setSuccessQRGenerateGif() {
        let successGif = UIImage.gifImageWithName("ghostSuccess")
        gifImageView.image = successGif
    }
    
    private func setupConstraints() {
        setGifImageViewConstraints()
        setTextInputConstraints()
        setGenerateQRCodeButtonConstraints()
    }
    
    private func setGifImageViewConstraints() {
        NSLayoutConstraint.activate([
            gifImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: layout.contentInsets.top),
            gifImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: layout.contentInsets.left),
            gifImageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: layout.contentInsets.right),
            gifImageView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    private func setTextInputConstraints() {
        NSLayoutConstraint.activate([
            textInput.topAnchor.constraint(equalTo: gifImageView.bottomAnchor, constant: 16),
            textInput.leftAnchor.constraint(equalTo: view.leftAnchor, constant: layout.contentInsets.left),
            textInput.rightAnchor.constraint(equalTo: view.rightAnchor, constant: layout.contentInsets.right),
            textInput.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setGenerateQRCodeButtonConstraints() {
        NSLayoutConstraint.activate([
            generateQRCodeButton.topAnchor.constraint(equalTo: textInput.bottomAnchor, constant: 50),
            generateQRCodeButton.widthAnchor.constraint(equalToConstant: Constants.generateQRCodeButtonWidth),
            generateQRCodeButton.heightAnchor.constraint(equalToConstant: Constants.generateQRCodeButtonHeight),
            generateQRCodeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

// MARK: - UITextFieldDelegate

extension QRCodeGeneratorViewController: UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if var text = textField.text {
            text.removeAll()
        }
        setupInitialState()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        gifImageView.contentMode = .scaleAspectFill
        setupInitialState()
        return true
    }
    
    private func setupInitialState() {
        returnInitialGenerateQRCodeButtonBehavior()
        setInitialGif()
    }
}

private enum Constants {
    static let textInputPlaceHolder: String = "Type/Copy/Paste your text/link"
    static let generateQRCodeButtonTitle: String = "Generate QR"
    static let shareTitle: String = "Share"
    static let cornerRadius: CGFloat = 2.0
    static let topInset: CGFloat = 80
    static let leftInset: CGFloat = 20
    static let rightInset: CGFloat = -20
    static let bottomInset: CGFloat = -40
    static let generateQRCodeButtonWidth: CGFloat = 150
    static let generateQRCodeButtonHeight: CGFloat = 70
    static let padding: UIEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
}

