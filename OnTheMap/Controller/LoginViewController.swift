//
//  ViewController.swift
//  OnTheMap
//
//  Created by Katharina Müllek on 23.01.21.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginWith: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.text = nil
        passwordTextField.text = nil
        textFieldMessage(emailMessage: Constants.Message.email, passwordMessage: Constants.Message.password)
        // Hide those Elements until Cocoapods are installed
        loginWith.isHidden = true
        googleButton.isHidden = true
        facebookButton.isHidden = true
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        setLoggingIn(true)
        loginUser()
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        UIApplication.shared.open(UdacityClient.Endpoints.signUp.url)
    }
    
    // Element hidden for now
    @IBAction func googleLoginTapped(_ sender: Any) {
        setLoggingIn(true)
        // https://developers.google.com/identity/sign-in/ios/start
    }
    
    // Element hidden for now
    @IBAction func facebookLoginTapped(_ sender: Any) {
        setLoggingIn(true)
        // https://developers.facebook.com/docs/facebook-login/ios
    }
    
    
    func loginUser() {
        if emailTextField.text != nil && passwordTextField.text != nil {
            let userEmail = emailTextField.text!.lowercased()
            let userPassword = passwordTextField.text!
            UdacityClient.login(username: userEmail, password: userPassword, completionHandler: handleLoginInformation(success:error:))
        } else {
            alertMessage(title: Constants.Alarm.enterEmailTitle, message: Constants.Alarm.invalidLoginMessage)
        }
    }
    
    func handleLoginInformation(success: Bool, error: Error?) {
        if success {
            UdacityClient.getUserInformation(completionHandler: handleGetUserInformation(success:error:))
        } else {
            setLoggingIn(false)
            alertMessage(title: Constants.Alarm.invalidLoginTitle, message: error!.localizedDescription)
            viewDidLoad()
        }
    }
    
    func handleGetUserInformation(success: Bool, error: Error?) {
        if success {
            setLoggingIn(false)
            performSegue(withIdentifier: Constants.Identifiers.loginSegueIdentifier, sender: self)
        } else {
            setLoggingIn(false)
        }
    }

    // making sure the User can't press any Buttons when Login Process is happening
    func setLoggingIn(_ loggingIn: Bool) {
        if loggingIn {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        emailTextField.isEnabled = !loggingIn
        passwordTextField.isEnabled = !loggingIn
        signupButton.isEnabled = !loggingIn
        /*
        googleButton.isEnabled = !loggingIn
        facebookButton.isEnabled = !loggingIn
         */
        loginButton.isEnabled = !loggingIn
    }

    func textFieldMessage(emailMessage: String, passwordMessage: String) {
        emailTextField.placeholder = emailMessage
        passwordTextField.placeholder = passwordMessage
    }

}

