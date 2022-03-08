//
//  MainNavigation.swift
//  ___PACKAGENAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___
//  ___COPYRIGHT___

import Foundation
import UIKit
import QMobileUI

/// The main navigation controller of your application. Which use tab bar as navigation mode.
/// see https://developer.apple.com/documentation/uikit/uitabbarcontroller
class MainNavigation: MainTabBarNavigationForm {

    override open func viewDidLoad() {
        super.viewDidLoad()
        customizeMoreView()
    }

}
