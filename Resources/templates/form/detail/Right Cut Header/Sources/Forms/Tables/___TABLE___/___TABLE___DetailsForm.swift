//
//  ___TABLE___DetailsForm.swift
//  ___PACKAGENAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___
//  ___COPYRIGHT___

import UIKit
import QMobileUI

/// Generated details form for ___TABLE___ table.
@IBDesignable
class ___TABLE___DetailsForm: DetailsForm___DETAILFORMTYPE___ {

    @IBInspectable var headerCutAway: CGFloat = 80
    @IBOutlet weak var contentView: UIView!
    var headerMaskLayer: CAShapeLayer?

    /// The record displayed in this form
    var record: ___TABLE___ {
        return super.record as! ___TABLE___
    }

    // MARK: Events
    override func onLoad() {
        // Do any additional setup after loading the view.
        headerMaskLayer = CAShapeLayer()
        headerMaskLayer?.fillColor=UIColor.black.cgColor
        contentView.layer.mask=headerMaskLayer
        let viewPath = UIBezierPath()
        viewPath.move(to: CGPoint(x: 0, y: headerCutAway))
        viewPath.addLine(to: CGPoint(x: screenWidth, y: 0))
        viewPath.addLine(to: CGPoint(x: screenWidth, y: contentView.frame.size.height))
        viewPath.addLine(to: CGPoint(x: 0, y: contentView.frame.size.height))
        headerMaskLayer?.path = viewPath.cgPath
    }

    override func onWillAppear(_ animated: Bool) {
        // Called when the view is about to made visible. Default does nothing
     
    }

    override func onDidAppear(_ animated: Bool) {
        // Called when the view has been fully transitioned onto the screen. Default does nothing
    }

    override func onWillDisappear(_ animated: Bool) {
        // Called when the view is dismissed, covered or otherwise hidden. Default does nothing
    }

    override func onDidDisappear(_ animated: Bool) {
        // Called after the view was dismissed, covered or otherwise hidden. Default does nothing
    }

    // MARK: Custom actions

}
// Screen width.
private var screenWidth: CGFloat {
    return UIScreen.main.bounds.width
}

// Screen height.
private var screenHeight: CGFloat {
    return UIScreen.main.bounds.height
}
