//
//  LoginVC.swift
//  ChatApp
//
//  Created by Aboody on 19/07/2021.
//

import UIKit
import ProgressHUD

class LoginVC: UIViewController {

    //MARK: - IBOutlets
    //labels
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var repeatPasswordLabel: UILabel!
    
    //textFields
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var signUpLabel: UILabel!
    
    //Buttons
    @IBOutlet weak var loginButtonOutlet: UIButton!
    @IBOutlet weak var signUpButtonOutlet: UIButton!
    @IBOutlet weak var resendEmailButtonOutlet: UIButton!
    
    //Views
    @IBOutlet weak var repeatPasswordLineView: UIView!
    
    //MARK: - Vars
    var isLogin: Bool = true
    
    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUIFor(login: true)
        setupTextFieldDelegates()
        setupBackgroundTap()
    }
    
    //MARK: - IBActions
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        if isDataInputedFor(type: isLogin ? "login" : "registration") {
            
            isLogin ? loginUser() : registerUser()
            
        } else {
            ProgressHUD.showFailed("All Fields are required.")
        }
    }
    @IBAction func forgotPasswordButtonPressed(_ sender: UIButton) {
        if isDataInputedFor(type: "password") {
            
            resetPassword()
        } else {
            ProgressHUD.showFailed("Email is required.")
        }
    }
    @IBAction func resendEmailButtonPressed(_ sender: UIButton) {
        if isDataInputedFor(type: "password") {
            resendVerificationEmail()
        } else {
            ProgressHUD.showFailed("Email is required.")
        }
    }
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        updateUIFor(login: sender.titleLabel?.text == "Login")
        isLogin.toggle()
    }
    
    //MARK: - Setup
    private func setupTextFieldDelegates() {
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        repeatPasswordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        updatePlaceholderLabels(textField: textField)
    }
    
    private func setupBackgroundTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func backgroundTap() {
        // hide keyboard after click on view
        view.endEditing(false)
    }
    
    //MARK: - Animations
    private func updateUIFor(login: Bool) {
        loginButtonOutlet.setImage(UIImage(named: login ? "loginBtn" : "registerBtn"), for: .normal)
        signUpButtonOutlet.setTitle(login ? "SignUp" : "Login", for: .normal)
        signUpLabel.text = login ? "Don't have an account?" : "Have an account?"
        
        UIView.animate(withDuration: 0.5) {
            self.repeatPasswordLabel.isHidden = login
            self.repeatPasswordTextField.isHidden = login
            self.repeatPasswordLineView.isHidden = login
        }
    }
    
    private func updatePlaceholderLabels(textField: UITextField) {
        
        switch textField {
        case emailTextField:
            emailLabel.text = textField.hasText ? "Email" : ""
        case passwordTextField:
            passwordLabel.text = textField.hasText ? "Password" : ""

        default:
            repeatPasswordLabel.text = textField.hasText ? "Repeat Password" : ""
        }
    }
    
    //MARK: - Helpers
    private func isDataInputedFor(type: String) -> Bool {
        
        switch type {
        case "login":
            return emailTextField.text != "" && passwordTextField.text != ""
        case "registration":
        return emailTextField.text != "" && passwordTextField.text != "" && repeatPasswordTextField.text != ""
        
        default:
            return emailTextField.text != ""
        }
    }
    
    private func loginUser() {
        FirebaseUserListener.shared.loginUserWithEmail(email: emailTextField.text!, password: passwordTextField.text!) { (error, isEmailVerified) in
            
            if error == nil {
                
                if isEmailVerified {
                    
//                    ProgressHUD.showSuccess("\(User.currentUser!.username) has logged successfully")
                    self.goToApp()
                } else {
                    ProgressHUD.showFailed("Please verify email.")
                    self.resendEmailButtonOutlet.isHidden = false
                }
                
            } else {
                ProgressHUD.showFailed(error?.localizedDescription)
            }
            
        }
    }
    
    private func registerUser() {
        
        if passwordTextField.text == repeatPasswordTextField.text {
            
            FirebaseUserListener.shared.registerUserWith(email: emailTextField.text!, password: passwordTextField.text!) { (error) in
                
                if error == nil {
                    ProgressHUD.showSuccess("Verification email sent.")
                    self.resendEmailButtonOutlet.isHidden = false
                } else {
                    ProgressHUD.showFailed(error?.localizedDescription)
                }
            }
            
        } else {
            ProgressHUD.showFailed("The Passwords don't match.")
        }
    }
    
    private func resetPassword() {
        
        FirebaseUserListener.shared.resetPasswordFor(email: emailTextField.text!) { (error) in
            
            if error == nil {
                
                ProgressHUD.showSuccess("Reset link sent to email.")
            } else {
                ProgressHUD.showFailed(error?.localizedDescription)
            }
        }
    }
    
    private func resendVerificationEmail() {
        FirebaseUserListener.shared.resendVerificationEmail(email: emailTextField.text!) { (error) in
            
            if error == nil {
                ProgressHUD.showSuccess("New verification email sent.")
            } else {
                ProgressHUD.showFailed(error?.localizedDescription)
            }
        }
    }
    
    //MARK: - Navigation
    private func goToApp() {

        let tabBar = BaseTBVC()
        tabBar.modalPresentationStyle = .fullScreen
        self.present(tabBar, animated: true, completion: nil)
    }
}
