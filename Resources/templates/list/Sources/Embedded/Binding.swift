//
//  Binding.swift
//  test
//
//  Created by Eric Marchand on 31/01/2018.
//  Copyright © 2018 My Company. All rights reserved.
//

import Foundation
import UIKit

// MARK: unknown behaviour

extension UIImageView {

    /// When there is nothing to display, you could provide a mock value.
    /// Default is the image named "unbinded".
    @objc open var unknown: Any? {
        get {
            return nil
        }
        set { // swiftlint:disable:this unused_setter_value
            // customize behaviour when binding on nothing
            self.image = UIImage(named: "unbinded")
        }
    }
}

extension UILabel {

    /// When there is nothing to display, you could provide a mock value.
    /// Default empty string.
    @objc open var unknown: Any? {
        get {
            return nil
        }
        set { // swiftlint:disable:this unused_setter_value
            // customize behaviour when binding on nothing
            // by default text is removed
            self.text = ""
        }
    }
}
