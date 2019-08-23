//
//  LoginForm.swift
//  ___PACKAGENAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___
//  ___COPYRIGHT___

import UIKit
import QMobileUI
import QMobileAPI
import AuthenticationServices

/// Delegate for login form
protocol LoginFormDelegate: NSObjectProtocol {
    /// Result of login operation.
    func didLogin(result: Result<AuthToken, APIError>) -> Bool
}

@IBDesignable
open class LoginForm: QMobileUI.LoginForm {
    
    @IBOutlet weak var separatorView: UIView!
    
    weak var delegate: LoginFormDelegate?
    
    var btnAuthorization: ASAuthorizationAppleIDButton? = nil
    
    // MARK: Event
    /// Called after the view has been loaded. Default does nothing
    open override func onLoad() {
    }
    /// Called when the view is about to made visible. Default does nothing
    open override func onWillAppear(_ animated: Bool) {
        setupSOAppleSignIn()
    }
    /// Called when the view has been fully transitioned onto the screen. Default does nothing
    open override func onDidAppear(_ animated: Bool) {
        performExistingAccountSetupFlows()
    }
    /// Called when the view is dismissed, covered or otherwise hidden. Default does nothing
    open override func onWillDisappear(_ animated: Bool) {
    }
    /// Called after the view was dismissed, covered or otherwise hidden. Default does nothing
    open override func onDidDisappear(_ animated: Bool) {
    }
    
    func setupSOAppleSignIn() {
        let btnAuthorization = ASAuthorizationAppleIDButton()
        btnAuthorization.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        btnAuthorization.cornerRadius = loginButton.normalCornerRadius

        btnAuthorization.addTarget(self, action: #selector(actionHandleAppleSignin(_:)), for: .touchUpInside)
        self.view.addSubview(btnAuthorization)

        btnAuthorization.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            btnAuthorization.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            btnAuthorization.bottomAnchor.constraint(equalTo: loginButton.topAnchor, constant: -56),
            btnAuthorization.widthAnchor.constraint(equalTo: loginButton.widthAnchor),
            btnAuthorization.heightAnchor.constraint(equalTo: loginButton.heightAnchor)
        ])
    }
    
    private func performExistingAccountSetupFlows() {
        // Prepare requests for both Apple ID and password providers.
        let requests = [ASAuthorizationAppleIDProvider().createRequest(), ASAuthorizationPasswordProvider().createRequest()]
        
        // Create an authorization controller with the given requests.
        let authorizationController = ASAuthorizationController(authorizationRequests: requests)
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    @objc func actionHandleAppleSignin(_ sender: ASAuthorizationAppleIDButton) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
        btnAuthorization = sender
    }
    
}

extension LoginForm: ASAuthorizationControllerDelegate {
    
    // ASAuthorizationControllerDelegate function for authorization failed
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("\(error)")
    }
    
    // ASAuthorizationControllerDelegate function for successful authorization
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            handle(appleIDCredential: appleIDCredential)
        case let passwordCredential as ASPasswordCredential:
            handle(passwordCredential: passwordCredential)
        default: break
        }
    }
    
}


extension LoginForm: ASAuthorizationControllerPresentationContextProviding {
    
    //For present window
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
}

extension LoginForm {
    
    private func handle(appleIDCredential: ASAuthorizationAppleIDCredential) {
        
        let email: String = appleIDCredential.email ?? ""
        let userId = appleIDCredential.user
        let firstname = appleIDCredential.fullName?.givenName
        let lastname = appleIDCredential.fullName?.familyName
        
        var parameters: [String: Any]? = nil
        parameters?["userId"] = userId
        parameters?["firstname"] = firstname
        parameters?["lastname"] = lastname
        
        APIManager.instance.authentificate(login: email, parameters: parameters) {  [weak self] result in
            
            guard let this = self else { return }
            
            // If success, transition (otherway to do that, ask a delegate to do it)
            switch result {
            case .success(let token):
                if token.isValidToken {
                    this.performTransition(this.btnAuthorization)
                }
            case .failure:
                break
            }
        }
    }
    
    private func handle(passwordCredential: ASPasswordCredential) {
        let appleUsername = passwordCredential.user
        let applePassword = passwordCredential.password
        // For the purpose of this demo app, show the password credential as an alert.
        DispatchQueue.main.async {
            let message = "The app has received your selected credential from the keychain. \n\n Username: \(appleUsername)\n Password: \(applePassword)"
            let alertController = UIAlertController(title: "Keychain Credential Received",
                                                    message: message,
                                                    preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
