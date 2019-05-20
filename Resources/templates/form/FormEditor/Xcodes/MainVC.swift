//
//  Main.swift
//  FormEditor
//
//  Created by Eric Marchand on 27/03/2018.
//  Copyright © 2018 4D. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
open class MainVC: UIViewController {

    open override func viewDidLoad() {

        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1) {
             self.performSegue(withIdentifier: "login", sender: nil)
        }
    }

}
