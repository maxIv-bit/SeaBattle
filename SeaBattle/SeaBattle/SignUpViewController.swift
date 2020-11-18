//
//  SignUpViewController.swift
//  SeaBattle
//
//  Created by Maks on 14.11.2020.
//

import UIKit
import SnapKit
import Firebase

class SignUpViewController: BaseViewController<SignUpViewModel> {
    private lazy var containerView = UIView()
    private lazy var emailTextField = UITextField()
    private lazy var passwordTextField = UITextField()
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
        }
    }
}

//  MARK: - Private
private extension SignUpViewController {
    func attachViews() {
        [containerView].forEach(view.addSubview)
        [emailTextField, passwordTextField, signUpButton].forEach(containerView.addSubview)
        
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
        
        signUpButton.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(10)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(50)
            $0.bottom.equalToSuperview()
        }
    }
    
    func configureUI() {
        emailTextField.placeholder = "Enter email"
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocorrectionType = .no
        
        passwordTextField.placeholder = "Enter password"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.autocorrectionType = .no
        
        signUpButton.setTitle("Log In", for: .normal)
        signUpButton.setTitleColor(.magenta, for: .normal)
        signUpButton.addTarget(self, action: #selector(signUpButtonTouchUpInside), for: .touchUpInside)
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
