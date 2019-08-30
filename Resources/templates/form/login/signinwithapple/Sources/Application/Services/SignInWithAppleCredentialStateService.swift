//
//  SignInWithAppleCredentialStateService.swift
//  ___PACKAGENAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___
//  ___COPYRIGHT___
//

import UIKit
import QMobileUI
import QMobileAPI
import AuthenticationServices
import Prephirences

/// A service which let us know if user has revoked credentials for this app.
///
/// KVC and @objc/NSObject provide a way to SDK to load this service.
@objc(SignInWithAppleCredentialStateService)
class SignInWithAppleCredentialStateService: NSObject {

    static var instance: SignInWithAppleCredentialStateService = SignInWithAppleCredentialStateService()

    override init() { }

    /// KVC to provide your instance.
    override class func value(forKey key: String) -> Any? {
        guard key == "instance" else { return nil }
        return SignInWithAppleCredentialStateService.instance
    }

}

// MARK: ApplicationService
extension SignInWithAppleCredentialStateService: ApplicationService {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        checkCredentialState()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {}

    func applicationWillEnterForeground(_ application: UIApplication) {
        checkCredentialState()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {}

    func applicationWillResignActive(_ application: UIApplication) {}

    func applicationWillTerminate(_ application: UIApplication) {}

    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {}

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {}

    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) {}

    fileprivate func checkCredentialState() {
        let defaults = UserDefaults.standard
        if let userID = defaults.string(forKey: "userID") {
            setupAppleIDCredentialObserver(userID: userID, completionHandler: { result in
                switch result {
                case .success(let credentialState):
                    switch credentialState {
                    case .authorized:
                        logger.info("Credentials authorized, user is authorized to continue.")
                    case .revoked:
                        logger.info("Credentials revoked, user has revoked access to this app.")
                        self.logoutRevokation()
                    case .notFound:
                        logger.info("Credentials not found, user has never signed in through Apple IDApplication has been authenticated with.")
                    default: break
                    }

                case .failure(let error):
                    logger.info("Getting credentials state returned an error: \(error)")
                    self.logoutRevokation()
                }

            })
        }
    }

    typealias CredentialStateCompletionHandler = ((Result<ASAuthorizationAppleIDProvider.CredentialState, Error>) -> Void)
    fileprivate func setupAppleIDCredentialObserver(userID: String, completionHandler: @escaping CredentialStateCompletionHandler) {
        let authorizationAppleIDProvider = ASAuthorizationAppleIDProvider()
        /// Getting credential state is only possible on a real device, so forget it on emulators
        authorizationAppleIDProvider.getCredentialState(forUserID: userID) { (credentialState: ASAuthorizationAppleIDProvider.CredentialState, error: Error?) in

            if let error = error {
                completionHandler(.failure(error))
                return
            }

            completionHandler(.success(credentialState))
        }
    }

    fileprivate func logoutRevokation() {
        _ = APIManager.instance.logout(token: Prephirences.Auth.Logout.token) { _ in
            Prephirences.Auth.Logout.token = nil

            let defaults = UserDefaults.standard
            defaults.set(nil, forKey: "userID")

            if let viewController = UIApplication.topViewController {
                self.logoutUI(nil, viewController)
            }
        }
    }

    fileprivate func logoutUI(_ sender: Any? = nil, _ source: UIViewController) {
        foreground {
            /// XXX check that there is no issue with that, view controller cycle for instance
            if let destination = Main.instantiate() {
                let identifier = "logout"
                // prepare destination like done with segue
                source.prepare(for: UIStoryboardSegue(identifier: identifier, source: source, destination: destination), sender: sender)
                // and present it
                source.present(destination, animated: true) {
                    logger.debug("\(destination) presented by \(source)")
                }
            }
        }
    }
}

