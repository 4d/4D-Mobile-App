//
//  main.swift
//  ___PACKAGENAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___
//  ___COPYRIGHT___

import Foundation
import UIKit
import QMobileUI

// Override main to inject 4D framework by settings QApplication as Application class
_ = UIApplicationMain(
    CommandLine.argc,
    CommandLine.unsafeArgv,
    NSStringFromClass(QApplication.self),
    NSStringFromClass(AppDelegate.self)
)
