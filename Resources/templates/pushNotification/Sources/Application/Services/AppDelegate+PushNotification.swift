//
//  AppDelegate+PushNotification.swift
//  ___PACKAGENAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___
//  ___COPYRIGHT___

import Foundation
import UIKit

//... in another file

// Fix apple compilator issue
private class FixAppleSwiftIssue: NSObject, UIApplicationDelegate {}

// Allow applications services to register to DeviceToken remote notification
extension AppDelegate {

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        type(of: self).application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }

}
