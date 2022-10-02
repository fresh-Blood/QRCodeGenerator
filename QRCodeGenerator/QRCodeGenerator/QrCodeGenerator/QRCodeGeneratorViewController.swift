//
//  QRCodeGeneratorViewController.swift
//  QRCodeGenerator
//
//  Created by Admin on 27.09.2022.
//

import UIKit

final class QRCodeGeneratorViewController: UIViewController {
    private let gradient = CAGradientLayer()
    private lazy var buttonAnimationStarted = false
    
    var randomColor: UIColor {
        .random()
    }
    
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
        imageView.layer.cornerRadius = Constants.cornerRadius
        imageView.backgroundColor = #colorLiteral(red: 0.1137115434, green: 0.1137344316, blue: 0.1137065217, alpha: 1)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var textInput: TextFieldWithPadding = {
        let textInput = TextFieldWithPadding(with: Constants.padding)
        textInput.translatesAutoresizingMaskIntoConstraints = false
        textInput.placeholder = Constants.textInputPlaceHolder
        textInput.font = .preferredFont(forTextStyle: .body, compatibleWith: .none)
        textInput.borderStyle = .roundedRect
        textInput.clearButtonMode = .whileEditing
        textInput.addTarget(self, action: #selector(showButtonReadyForActionIfNeeded), for: .editingChanged)
        return textInput
    }()
    
    private lazy var generateQRCodeButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = Constants.cornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Constants.generateQRCodeButtonTitle, for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .headline, compatibleWith: .current)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(generateQRCode), for: .touchUpInside)
        return button
    }()
    
    // MARK: - LifeCycle
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textInput.delegate = self
        setupUI()
    }
    
    // MARK: SetupUI
    
    private func setupUI() {
        view.backgroundColor = #colorLiteral(red: 0.1137115434, green: 0.1137344316, blue: 0.1137065217, alpha: 1)
        view.addSubview(gifImageView)
        view.addSubview(textInput)
        view.addSubview(generateQRCodeButton)
        setupConstraints()
        setInitialGif()
        setGradientLayer()
    }
    
    private func setGradientLayer() {
        gradient.frame = view.bounds
        gradient.colors = [#colorLiteral(red: 0.1137115434, green: 0.1137344316, blue: 0.1137065217, alpha: 1).cgColor,#colorLiteral(red: 0.1137115434, green: 0.1137344316, blue: 0.1137065217, alpha: 1).cgColor,#colorLiteral(red: 0.1137115434, green: 0.1137344316, blue: 0.1137065217, alpha: 1).cgColor, randomColor.cgColor]
        view.layer.insertSublayer(gradient, at: .zero)
    }
    
    private func setLoadingGradientColors() {
        gradient.colors = [#colorLiteral(red: 0.09455946833, green: 0.0983896032, blue: 0.1054966673, alpha: 1).cgColor,#colorLiteral(red: 0.09455946833, green: 0.0983896032, blue: 0.1054966673, alpha: 1).cgColor,#colorLiteral(red: 0.09455946833, green: 0.0983896032, blue: 0.1054966673, alpha: 1).cgColor, randomColor.cgColor]
    }
    
    private func setSuccessGradientColors() {
        gradient.colors = [#colorLiteral(red: 0.1019478217, green: 0.1019691005, blue: 0.1019431427, alpha: 1).cgColor,#colorLiteral(red: 0.1019478217, green: 0.1019691005, blue: 0.1019431427, alpha: 1).cgColor,#colorLiteral(red: 0.1019478217, green: 0.1019691005, blue: 0.1019431427, alpha: 1).cgColor, randomColor.cgColor]
        gifImageView.backgroundColor = #colorLiteral(red: 0.1019478217, green: 0.1019691005, blue: 0.1019431427, alpha: 1)
    }
    
    private func setInitialGradientColors() {
        gradient.colors = [#colorLiteral(red: 0.1137115434, green: 0.1137344316, blue: 0.1137065217, alpha: 1).cgColor,#colorLiteral(red: 0.1137115434, green: 0.1137344316, blue: 0.1137065217, alpha: 1).cgColor,#colorLiteral(red: 0.1137115434, green: 0.1137344316, blue: 0.1137065217, alpha: 1).cgColor, randomColor.cgColor]
        gifImageView.backgroundColor = #colorLiteral(red: 0.1137115434, green: 0.1137344316, blue: 0.1137065217, alpha: 1)
    }
    
    private func setupConstraints() {
        setGifImageViewConstraints()
        setTextInputConstraints()
        setGenerateQRCodeButtonConstraints()
    }
    
    private func setGifImageViewConstraints() {
        let gifImageViewHeightAnchorValue = view.frame.width - layout.contentInsets.left*2
        
        NSLayoutConstraint.activate([
            gifImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: layout.contentInsets.top + view.safeAreaInsets.top),
            gifImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: layout.contentInsets.left),
            gifImageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: layout.contentInsets.right),
            gifImageView.heightAnchor.constraint(equalToConstant: gifImageViewHeightAnchorValue)
        ])
    }
    
    private func setTextInputConstraints() {
        NSLayoutConstraint.activate([
            textInput.topAnchor.constraint(equalTo: gifImageView.bottomAnchor, constant: Constants.textInputTopAnchorValue),
            textInput.leftAnchor.constraint(equalTo: view.leftAnchor, constant: layout.contentInsets.left),
            textInput.rightAnchor.constraint(equalTo: view.rightAnchor, constant: layout.contentInsets.right),
            textInput.heightAnchor.constraint(equalToConstant: Constants.textInputHeightAnchorValue)
        ])
    }
    
    private func setGenerateQRCodeButtonConstraints() {
        NSLayoutConstraint.activate([
            generateQRCodeButton.topAnchor.constraint(equalTo: textInput.bottomAnchor, constant: Constants.generateQRCodeButtonTopAnchorValue),
            generateQRCodeButton.widthAnchor.constraint(equalToConstant: Constants.generateQRCodeButtonWidth),
            generateQRCodeButton.heightAnchor.constraint(equalToConstant: Constants.generateQRCodeButtonHeight),
            generateQRCodeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc
    private func showButtonReadyForActionIfNeeded() {
        guard let inputText = textInput.text else { return }
        if inputText.isEmpty {
            buttonAnimationStarted = false
            setInitialButtonLayerConfiguration()
        } else {
            guard !buttonAnimationStarted else { return }
            setReadyForActionButtonLayerConfiguration()
            buttonAnimationStarted = true
        }
    }
    
    private func setInitialButtonLayerConfiguration() {
        generateQRCodeButton.layer.borderWidth = .zero
        generateQRCodeButton.layer.borderColor = UIColor.clear.cgColor
        generateQRCodeButton.layer.shadowColor = UIColor.clear.cgColor
        removeButtonShadowAnimation()
    }
    
    private func removeButtonShadowAnimation() {
        generateQRCodeButton.layer.removeAllAnimations()
    }
    
    private func setReadyForActionButtonLayerConfiguration() {
        generateQRCodeButton.layer.shadowColor = UIColor.white.cgColor
        generateQRCodeButton.layer.shadowOffset = CGSize(width: 2, height: 3)
        generateQRCodeButton.layer.shadowRadius = 7.0
        generateQRCodeButton.layer.shadowOpacity = 1.0
        animateButtonShadow()
    }
    
    private func animateButtonShadow() {
        let animation = CABasicAnimation(keyPath: "shadowOpacity")
        animation.fromValue = generateQRCodeButton.layer.shadowOpacity
        animation.toValue = 0.3
        animation.duration = Constants.shadowAnimationDuration
        animation.repeatCount = .infinity
        animation.autoreverses = true
        generateQRCodeButton.layer.add(animation, forKey: animation.keyPath)
        generateQRCodeButton.layer.shadowOpacity = .zero
    }
    
    // MARK: - GenerateQRCode
    @objc
    private func generateQRCode() {
        guard let textToGenerateQRCode = textInput.text,
              !textToGenerateQRCode.isEmpty else { return }
        animateButton()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: { [weak self] in
            guard let self = self else { return }
            self.view.endEditing(true)
            self.disableUserInteraction()
            self.setLoadingGif()
            self.setLoadingGradientColors()
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.loadingAnimationDuration, execute: { [weak self] in
            self?.generate(with: textToGenerateQRCode)
            self?.setInitialGradientColors()
        })
    }
    
    private func setLoadingGif() {
        let loadingGif = UIImage.gifImageWithName("loading")
        gifImageView.image = loadingGif
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
                enrichGifImageViewWith(cgImage)
            } else {
                configureErrorBehavior()
                enableUserInteraction()
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
            self.generateQRCodeButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        },
                       completion: { [weak self] _ in
            UIView.animate(withDuration: 0.2,
                           delay: .zero,
                           usingSpringWithDamping: 0.1,
                           initialSpringVelocity: 0.5,
                           options: .curveEaseOut,
                           animations: {
                self?.generateQRCodeButton.transform = CGAffineTransform.identity
            })
        })
    }
    
    private func enrichGifImageViewWith(_ cgImage: CGImage) {
        VibrateManager.vibrateSuccess()
        gifImageView.contentMode = .scaleAspectFit
        gifImageView.image = UIImage(cgImage: cgImage)
        enableUserInteraction()
        setShareQRCodeButtonBehavior()
    }
    
    private func setShareQRCodeButtonBehavior() {
        generateQRCodeButton.removeTarget(self, action: #selector(generateQRCode), for: .touchUpInside)
        generateQRCodeButton.setTitle(Constants.shareTitle, for: .normal)
        generateQRCodeButton.addTarget(self, action: #selector(share), for: .touchUpInside)
    }
    
    private func configureErrorBehavior() {
        setErrorGif()
        VibrateManager.vibrateFailure()
    }
    
    private func setErrorGif() {
        let errorGif = UIImage.gifImageWithName("ghostError")
        gifImageView.image = errorGif
    }
    
    private func enableUserInteraction() {
        textInput.isUserInteractionEnabled = true
        generateQRCodeButton.isUserInteractionEnabled = true
    }
    
    private func disableUserInteraction() {
        textInput.isUserInteractionEnabled = false
        generateQRCodeButton.isUserInteractionEnabled = false
    }
    
    // MARK: - Share
    @objc
    private func share() {
        guard let qrCodeImage = gifImageView.image else { return }
        animateButton()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: { [weak self] in
            guard let self = self else { return }
            self.setSuccessQRGenerateGif()
            self.setSuccessGradientColors()
            let imageToShare = [ qrCodeImage ]
            let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
            activityViewController.completionWithItemsHandler = { [weak self] activity, success, items, error in
                let completionShouldBeCalled = error != nil || success || activity == nil
                if completionShouldBeCalled {
                    self?.configureShareCompletion()
                }
            }
        })
    }
    
    private func configureShareCompletion() {
        returnInitialGenerateQRCodeButtonBehavior()
        textInput.text?.removeAll()
        gifImageView.contentMode = .scaleAspectFill
        setInitialGif()
        setInitialButtonLayerConfiguration()
        buttonAnimationStarted = false
        setInitialGradientColors()
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
    
    private func setSuccessQRGenerateGif() {
        let successGif = UIImage.gifImageWithName("ghostSuccess")
        gifImageView.image = successGif
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

