//
//  AuthViewController.swift
//  SeaBattle
//
//  Created by Maks on 14.11.2020.
//

import UIKit
import SnapKit
import Firebase

class AuthViewController: BaseViewController<AuthViewModel> {
    private lazy var backgroundImageView = UIImageView()
    private lazy var containerView = UIView()
    private lazy var emailTextField = BackdownTextFieldView()
    private lazy var passwordTextField = BackdownTextFieldView()
    private lazy var signInButton = UIButton()
    private lazy var signUpButton = UIButton()
    private var logInButtonTopConstraint: Constraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attachViews()
        configureUI()
        configureBindings()
    }
    
    override func performOnceInViewDidAppearOnLayoutUpdate() {
        [emailTextField, passwordTextField].forEach {
            $0.layer.setBorder(lineWidth: 2.0)
            $0.layer.addShadow()
        }
        signInButton.layer.setGradient(colors: [UIColor.red.cgColor, UIColor.yellow.cgColor, UIColor.blue.cgColor], locations: [0.0, 0.35, 0.7])?.animateGradient(fromValue: [0.0, 0.35, 0.7], toValue: [0.4, 0.65, 0.9])
        signInButton.layer.addText("Sign In", color: UIColor.white.cgColor, fontSize: 40)
        signInButton.layer.addShadow()
        
        signUpButton.layer.setGradient(colors: [UIColor.blue.cgColor, UIColor.orange.cgColor, UIColor.yellow.cgColor], locations: [0.0, 0.35, 0.7])?.animateGradient(fromValue: [0.0, 0.35, 0.7], toValue: [0.4, 0.65, 0.9])
        signUpButton.layer.addText("Sign Up", color: UIColor.white.cgColor, fontSize: 40)
        signUpButton.layer.addShadow()
    }
}

//  MARK: - Private
private extension AuthViewController {
    func attachViews() {
        [backgroundImageView].forEach(view.addSubview)
        [containerView].forEach(backgroundImageView.addSubview)
        [emailTextField, passwordTextField, signInButton, signUpButton].forEach(containerView.addSubview)
        
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.right.equalToSuperview().inset(20)
        }
        
        emailTextField.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(10)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        signInButton.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(10)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        signUpButton.snp.makeConstraints {
            $0.top.equalTo(signInButton.snp.bottom).offset(10)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(50)
            $0.bottom.equalToSuperview()
        }
    }
    
    func configureUI() {
        backgroundImageView.image = UIImage(named: "SeaBattleIntroScreen")
        backgroundImageView.isUserInteractionEnabled = true
        
        emailTextField.placeholder = "Enter email"
        emailTextField.keyboardType = .emailAddress
        emailTextField.returnKeyType = .next
        
        passwordTextField.placeholder = "Enter password"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.returnKeyType = .done
        
        [emailTextField, passwordTextField].forEach {
            $0.backdown = 20
            $0.autocapitalizationType = .none
            $0.autocorrectionType = .no
            $0.textColor = .white
            $0.delegate = self
        }
        
        signInButton.addTarget(self, action: #selector(signInButtonTouchUpInside), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpButtonTouchUpInside), for: .touchUpInside)
    }
    
    @objc func signInButtonTouchUpInside(_ sender: UIButton) {
        viewModel.signUp(email: emailTextField.text, password: passwordTextField.text)
    }
    
    @objc func signUpButtonTouchUpInside(_ sender: UIButton) {
        viewModel.signUp(email: emailTextField.text, password: passwordTextField.text)
    }
    
    func configureBindings() {
        viewModel.onInvalidEmail = { error in
            UIAlertController.showOkAlert(message: error, viewController: UIViewController.pvc())
        }
        
        viewModel.onInvalidPassword = { error in
            UIAlertController.showOkAlert(message: error, viewController: UIViewController.pvc())
        }
        
        viewModel.onError = { error in
            UIAlertController.showOkAlert(message: error, viewController: UIViewController.pvc())
        }
    }
}

// MARK: - UITextFieldDelegate
extension AuthViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            if textField.returnKeyType == .done {
                textField.resignFirstResponder()
            } else {
                passwordTextField.becomeFirstResponder()
            }
        default:
            textField.resignFirstResponder()
        }
        return true
    }
}
