//
//  LoginForm.swift
//  ___PACKAGENAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___
//  ___COPYRIGHT___

import UIKit
import QMobileUI
import AuthenticationServices

@IBDesignable
open class LoginForm: QMobileUI.LoginForm {

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
        btnAuthorization.cornerRadius = 22
        
        btnAuthorization.addTarget(self, action: #selector(actionHandleAppleSignin), for: .touchUpInside)
        self.view.addSubview(btnAuthorization)
        
        btnAuthorization.translatesAutoresizingMaskIntoConstraints = false
        if let seperatorView = self.view.viewWithTag(539), let loginView = self.view.viewWithTag(109) {
            NSLayoutConstraint.activate([
                btnAuthorization.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                btnAuthorization.bottomAnchor.constraint(equalTo: seperatorView.topAnchor, constant: -10),
                btnAuthorization.widthAnchor.constraint(equalTo: loginView.widthAnchor),
                btnAuthorization.heightAnchor.constraint(equalTo: loginView.heightAnchor)
            ])
        }
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
    
    @objc func actionHandleAppleSignin() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }

}
extension LoginForm: ASAuthorizationControllerDelegate {
    
    // ASAuthorizationControllerDelegate function for authorization failed
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("\(error)")
    }
    
    // ASAuthorizationControllerDelegate function for successful authorization
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
    }
}


extension LoginForm: ASAuthorizationControllerPresentationContextProviding {
    
    //For present window
    
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
}

