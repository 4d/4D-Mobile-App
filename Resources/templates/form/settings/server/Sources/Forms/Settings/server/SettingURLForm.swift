//
//  SettingURLForm.swift
//  ___PACKAGENAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___
//  ___COPYRIGHT___

import UIKit
import QMobileUI

open class SettingURLForm: QMobileUI.SettingURLForm {

    // MARK: Event
    /// Called after the view has been loaded. Default does nothing
    open override func onLoad() {
    }
    /// Called when the view is about to made visible. Default does nothing
    open override func onWillAppear(_ animated: Bool) {
    }
    /// Called when the view has been fully transitioned onto the screen. Default does nothing
    open override func onDidAppear(_ animated: Bool) {
    }
    /// Called when the view is dismissed, covered or otherwise hidden. Default does nothing
    open override func onWillDisappear(_ animated: Bool) {
    }
    /// Called after the view was dismissed, covered or otherwise hidden. Default does nothing
    open override func onDidDisappear(_ animated: Bool) {
    }

    // MARK: IBOutlet
    @IBOutlet open override weak var serverURLTextField: UITextField! {
        get {
            return super.serverURLTextField
        }
        set {
            super.serverURLTextField = newValue
        }
    }

    // MARK: action
    @IBAction open override func serverURLTextFieldEndEditing(_ sender: Any?) {
        super.serverURLTextFieldEndEditing(sender)
    }
}
