//
//  MainNavigation.swift
//  ___PACKAGENAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___
//  ___COPYRIGHT___

import Foundation
import UIKit

/// The main navigation controller of your application. Which use tab bar as navigation mode.
/// see https://developer.apple.com/documentation/uikit/uitabbarcontroller
class MainNavigation: UITabBarController {

    override open func viewDidLoad() {
        super.viewDidLoad()
        customizeMoreView()
    }

}

extension MainNavigation {

    func customizeMoreView() {
        if let moreListViewController = moreNavigationController.topViewController {
            if let moreTableView = moreListViewController.view as? UITableView {
                moreTableView.tintColor = .background // To set color on  "more" panel table icon
                moreTableView.tableFooterView = UIView() // remove footer
                // moreTableView.separatorStyle = .none // to remove all separator
            }
        }
        let navigationBar = self.moreNavigationController.navigationBar
        navigationBar.tintColor = .foreground
        navigationBar.barTintColor = .background
    }
}

extension UIColor {
    static let background = UIColor(named: "BackgroundColor")
    static let foreground = UIColor(named: "ForegroundColor")
}
