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
    
    lazy var btnAuthorization = ASAuthorizationAppleIDButton()

    
    // MARK: Event
    /// Called after the view has been loaded. Default does nothing
    open override func onLoad() {
    }
    /// Called when the view is about to made visible. Default does nothing
    open override func onWillAppear(_ animated: Bool) {
        setupAppleSignInButton()
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
    
    // MARK: - ASAuthorizationAppleIDButton
    
    func setupAppleSignInButton() {

        setupViewWithTrait(traitCollection: self.traitCollection)
        btnAuthorization.frame = CGRect()
        btnAuthorization.cornerRadius = loginButton.normalCornerRadius
        btnAuthorization.addTarget(self, action: #selector(handleAppleSignInButtonPress(_:)), for: .touchUpInside)
        self.view.addSubview(btnAuthorization)
        
        btnAuthorization.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            btnAuthorization.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            btnAuthorization.bottomAnchor.constraint(equalTo: loginButton.topAnchor, constant: -56),
            btnAuthorization.widthAnchor.constraint(equalTo: loginButton.widthAnchor),
            btnAuthorization.heightAnchor.constraint(equalTo: loginButton.heightAnchor)
        ])
    }
    
    override open func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {}

    override open func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        // Trait collection will change. Use this one so you know what the state is changing to.
        setupViewWithTrait(traitCollection: newCollection)
    }
    
    private func setupViewWithTrait(traitCollection: UITraitCollection) {
        if traitCollection.userInterfaceStyle == .dark {
            btnAuthorization = ASAuthorizationAppleIDButton(type: .signIn, style: .white)
            loginTextField.textColor = .white
        } else {
            btnAuthorization = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
            loginTextField.textColor = .black
        }
    }
    
    // MARK: - ASAuthorizationController
    
    private func performExistingAccountSetupFlows() {
        // Prepare requests for both Apple ID and password providers.
        let requests = [ASAuthorizationAppleIDProvider().createRequest(), ASAuthorizationPasswordProvider().createRequest()]
        
        // Create an authorization controller with the given requests.
        let authorizationController = ASAuthorizationController(authorizationRequests: requests)
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    @objc func handleAppleSignInButtonPress(_ sender: ASAuthorizationAppleIDButton) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let authorizationAppleIDRequest = appleIDProvider.createRequest()
        authorizationAppleIDRequest.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [authorizationAppleIDRequest])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
        btnAuthorization = sender
    }
    
    private func setupAppleIDCredentialObserver(userID: String) {
        let authorizationAppleIDProvider = ASAuthorizationAppleIDProvider()
        
        authorizationAppleIDProvider.getCredentialState(forUserID: userID) { (credentialState: ASAuthorizationAppleIDProvider.CredentialState, error: Error?) in
            // Getting credential state is only possible on a real device, so forget it on emulators
            if let error = error {
                print("Getting credential state returned an error: \(error)")
                return
            }
            switch (credentialState) {
            case .authorized:
                //User is authorized to continue using your app
                break
            case .revoked:
                //User has revoked access to your app
//                self.logout()
                break
            case .notFound:
                //User is not found, meaning that the user never signed in through Apple ID
                break
            default: break
            }
        }
    }
    
    private func registerForAppleIDSessionChanges() {
        let notificationCenter = NotificationCenter.default
        let sessionNotificationName = ASAuthorizationAppleIDProvider.credentialRevokedNotification
        
        let _ = notificationCenter.addObserver(forName: sessionNotificationName, object: nil, queue: nil) { (notification: Notification) in
            //Sign user out
//            self.logout()
        }
    }
    
}

// MARK: - ASAuthorizationControllerDelegate

extension LoginForm: ASAuthorizationControllerDelegate {
    
    // ASAuthorizationControllerDelegate function for authorization failed
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Authorization returned an error: \(error.localizedDescription)")
    }
    
    // ASAuthorizationControllerDelegate function for successful authorization
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        registerForAppleIDSessionChanges()
        
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            setupAppleIDCredentialObserver(userID: appleIDCredential.user)
            handleAppleIDCredential(appleIDCredential: appleIDCredential)
        case let passwordCredential as ASPasswordCredential:
            setupAppleIDCredentialObserver(userID: passwordCredential.user)
            handlePasswordCredential(passwordCredential: passwordCredential)
        default: break
        }
    }
    
}

// MARK: - ASAuthorizationControllerPresentationContextProviding

extension LoginForm: ASAuthorizationControllerPresentationContextProviding {
    
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
}

// MARK: - Authentication

extension LoginForm {
    
    private func handleAppleIDCredential(appleIDCredential: ASAuthorizationAppleIDCredential) {
        
        let email: String = appleIDCredential.email ?? ""
        let userId = appleIDCredential.user
        let firstname = appleIDCredential.fullName?.givenName
        let lastname = appleIDCredential.fullName?.familyName
        
        var parameters: [String: Any]? = nil
        parameters?["userId"] = userId
        parameters?["firstname"] = firstname
        parameters?["lastname"] = lastname
        
        authentificate(login: email, parameters: parameters)
    }
    
    private func handlePasswordCredential(passwordCredential: ASPasswordCredential) {
        
        let appleUsername = passwordCredential.user
        let applePassword = passwordCredential.password
        
        var parameters: [String: Any]? = nil
        parameters?["password"] = applePassword
        
        authentificate(login: appleUsername, parameters: parameters)
    }
    
    private func authentificate(login: String, parameters: [String: Any]?) {
        let _ = APIManager.instance.authentificate(login: email, parameters: parameters) {  [weak self] result in
            
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
    
//    private func logout() {
//        _ = APIManager.instance.logout { result in
//            logger.info("Logout \(result)")
//
//            self.performTransition()
//        }
//    }
    
}
