//
//  ViewController.swift
//  CU Study Buddies
//
//  Created by Jordan Wood on 12/5/23.
//

import UIKit

class LoginViewController: UIViewController {

    let logoImageView = UIImageView()
    let loginButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLogoImageView()
        setupLoginButton()
    }

    private func setupView() {
        self.setBackgroundToGrain()
    }

    private func setupLogoImageView() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoImageView)

        // Configure the image view here (e.g., set an image for the logo)
         logoImageView.image = UIImage(named: "Colorado_Buffaloes_logo")

        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50), // Adjust position as needed
            logoImageView.widthAnchor.constraint(equalToConstant: 100), // Adjust size as needed
            logoImageView.heightAnchor.constraint(equalToConstant: 75) // Adjust size as needed
        ])
    }

    private func setupLoginButton() {
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginButton)

        loginButton.setTitle("Login with CU Identity Service", for: .normal)
        loginButton.backgroundColor = .white
        loginButton.tintColor = .black
        loginButton.setTitleColor(.black, for: .normal)
        loginButton.layer.cornerRadius = 5
        loginButton.titleLabel?.font = ComfortaaFont.bold.font(size: FontSizeManager.fontSize(for: .body) - 2)

        // Add target/action for button tap here
         loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20), // Adjust position as needed
            loginButton.widthAnchor.constraint(equalToConstant: 220), // Adjust size as needed
            loginButton.heightAnchor.constraint(equalToConstant: 40) // Adjust size as needed
        ])
    }

    // Example action method for login button tap
     @objc private func loginButtonTapped() {
         // Handle login action
         print("Login button tapped, presenting the main screen")
         // TODO: - Actually integrate with CU login service and do appropriate action
         self.navigationController?.pushViewController(HomeViewController(), animated: true)

     }
    
    
}

extension UIViewController {
    
    func setBackgroundToGrain() {
        if let grainyTexture = generateNoiseImage(size: view.bounds.size, opacity: 0.05) {
            self.view.backgroundColor = UIColor(patternImage: grainyTexture)
        }
    }
    
    // helper func to create the grainy background texture
    func generateNoiseImage(size: CGSize, opacity: Float) -> UIImage? {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)

        guard let context = UIGraphicsGetCurrentContext() else { return nil }

        context.setFillColor(UIColor.systemGray6.cgColor)
        context.fill(rect)

        let count = Int(size.width * size.height)
        let bytes = [UInt8](repeating: 0, count: count).map { _ in
            return UInt8.random(in: 0...255)
        }

        if let data = CFDataCreate(nil, bytes, count),
           let provider = CGDataProvider(data: data),
           let cgImage = CGImage(width: Int(size.width),
                                 height: Int(size.height),
                                 bitsPerComponent: 8,
                                 bitsPerPixel: 8,
                                 bytesPerRow: Int(size.width),
                                 space: CGColorSpaceCreateDeviceGray(),
                                 bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue),
                                 provider: provider,
                                 decode: nil,
                                 shouldInterpolate: false,
                                 intent: .defaultIntent) {
            context.setAlpha(CGFloat(opacity))
            context.draw(cgImage, in: rect)
        }

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }

}
