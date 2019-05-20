//
//  ___TABLE___ListForm.swift
//  ___PACKAGENAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___
//  ___COPYRIGHT___

import UIKit
import QMobileUI

/// Generated list form for ___TABLE___ table.
@IBDesignable

class ___TABLE___CustomProgressBarList: UIView {
    @IBInspectable var percent: CGFloat = 0.90
    @IBInspectable var oldpercent: CGFloat = 0
    @objc dynamic public var graphnumber: NSNumber? {
        get {
            return (percent) as NSNumber
        }
        set {
            oldpercent = self.percent
            guard let number = newValue else {
                self.percent = 0
                return
            }
            percent = (CGFloat(number.doubleValue))
            setNeedsDisplay()
        }
    }
    let greenColor = UIColor(red: 119/255, green: 194/255, blue: 175/255, alpha: 1.0)
    let yellowColor = UIColor(red: 242/255, green: 194/255, blue: 86/255, alpha: 1.0)
    let orangeColor = UIColor(red: 243/255, green: 121/255, blue: 68/255, alpha: 1.0)
    let redColor = UIColor(red: 220/255, green: 81/255, blue: 79/255, alpha: 1.0)
    let greyColor = UIColor(red: 218/255, green: 218/255, blue: 218/255, alpha: 1.0)

    override func draw(_ rect: CGRect) {
        let backgroundPath = UIBezierPath()
        backgroundPath.move(to: CGPoint(x: 0, y: self.frame.height))
        backgroundPath.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
        let backShapelayer = CAShapeLayer()
        backShapelayer.path = backgroundPath.cgPath
        backShapelayer.strokeColor = greyColor.cgColor
        backShapelayer.lineWidth = self.frame.height
        self.layer.addSublayer(backShapelayer)
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: self.frame.height))
        if percent <= 100 && percent > 0 {
            path.addLine(to: CGPoint(x: (percent * self.frame.width) / 100, y: self.frame.height))}
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = self.frame.height
        switch percent {
        case 75...100 :
            shapeLayer.strokeColor = greenColor.cgColor
        case 50...74 :
            shapeLayer.strokeColor = yellowColor.cgColor
        case 25...49 :
            shapeLayer.strokeColor = orangeColor.cgColor
        case 0...24 :
            shapeLayer.strokeColor = redColor.cgColor
        default:
            shapeLayer.strokeColor = greyColor.cgColor
        }
        self.layer.addSublayer(shapeLayer)
    }
}

class ___TABLE___ListForm: ListForm___LISTFORMTYPE___ {

    // Do not edit name or override tableName
    public override var tableName: String {
        return "___TABLE___"
    }

    // MARK: Events
    override func onLoad() {
        // Do any additional setup after loading the view.
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

}
