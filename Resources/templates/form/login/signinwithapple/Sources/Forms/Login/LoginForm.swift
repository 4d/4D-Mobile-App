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

@IBDesignable
open class LoginForm: QMobileUI.LoginForm {

    @IBOutlet weak var separatorView: UIView!

    lazy var btnAuthorization = ASAuthorizationAppleIDButton()

    // MARK: Event
    /// Called after the view has been loaded. Default does nothing
    open override func onLoad() {
        btnAuthorization.isEnabled = true
    }
    /// Called when the view is about to made visible. Default does nothing
    open override func onWillAppear(_ animated: Bool) {
//        registerForAppleIDSessionChanges()
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
    /// Function call before launch standard login.
    open override func onWillLogin() {
        // Disable Sign In with Apple while basic mail login in progress
        btnAuthorization.isEnabled = false
    }
    /// Function after launching login process.
    open override func onDidLogin(result: Result<AuthToken, APIError>) {
        /// Release the disability of Sign In with Apple in case basic mail login failed
        switch result {
        case .success(let token):
            if !token.isValidToken {
                btnAuthorization.isEnabled = true
            }
        case .failure:
            btnAuthorization.isEnabled = true
        }
    }

    // MARK: - ASAuthorizationAppleIDButton

    fileprivate func setupAppleSignInButton() {

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

    override open func traitCollectionDidChange (_ previousTraitCollection: UITraitCollection?) {}

    override open func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        /// Trait collection will change. Use this one so you know what the state is changing to.
        setupViewWithTrait(traitCollection: newCollection)
    }

    fileprivate func setupViewWithTrait(traitCollection: UITraitCollection) {
        if traitCollection.userInterfaceStyle == .dark {
            btnAuthorization = ASAuthorizationAppleIDButton(type: .signIn, style: .whiteOutline)
            loginTextField.textColor = .white
        } else {
            btnAuthorization = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
            loginTextField.textColor = .black
        }
    }

    // MARK: - ASAuthorizationController

    fileprivate func performExistingAccountSetupFlows() {
        /// Prepare requests for both Apple ID and password providers.
        let requests = [ASAuthorizationAppleIDProvider().createRequest(), ASAuthorizationPasswordProvider().createRequest()]

        /// Create an authorization controller with the given requests.
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

}

// MARK: - ASAuthorizationControllerDelegate

extension LoginForm: ASAuthorizationControllerDelegate {

    /// ASAuthorizationControllerDelegate function for authorization failed
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Authorization returned an error: \(error.localizedDescription)")
    }

    /// ASAuthorizationControllerDelegate function for successful authorization
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {

        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            handleAppleIDCredential(appleIDCredential: appleIDCredential)
        case let passwordCredential as ASPasswordCredential:
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

    fileprivate func handleAppleIDCredential(appleIDCredential: ASAuthorizationAppleIDCredential) {

        let email: String = appleIDCredential.email ?? ""
        let userId = appleIDCredential.user
        let firstname = appleIDCredential.fullName?.givenName
        let lastname = appleIDCredential.fullName?.familyName

        var parameters: [String: Any]?
        parameters?["userId"] = userId
        parameters?["firstname"] = firstname
        parameters?["lastname"] = lastname

        saveUserID(userID: userId)
        authentificate(login: email, parameters: parameters)
    }

    // Sign in using an existing iCloud Keychain credential
    fileprivate func handlePasswordCredential(passwordCredential: ASPasswordCredential) {

        let appleUsername = passwordCredential.user
        let applePassword = passwordCredential.password

        var parameters: [String: Any]?
        parameters?["password"] = applePassword

        saveUserID(userID: appleUsername)
        authentificate(login: appleUsername, parameters: parameters)
    }

    fileprivate func saveUserID(userID: String) {
        SignInWithAppleCredentialStateService.userId = userID
    }

    fileprivate func authentificate(login: String, parameters: [String: Any]?) {
        _ = APIManager.instance.authentificate(login: email, parameters: parameters) {  [weak self] result in

            guard let this = self else { return }

            this.onDidLogin(result: result)
            _ = this.delegate?.didLogin(result: result)

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

}
