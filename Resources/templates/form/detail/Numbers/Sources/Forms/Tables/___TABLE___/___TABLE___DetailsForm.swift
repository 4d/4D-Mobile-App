//
//  ___TABLE___DetailsForm.swift
//  ___PACKAGENAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___
//  ___COPYRIGHT___

import UIKit
import QMobileUI
import DeviceKit

/// Generated details form for ___TABLE___ table.
@IBDesignable
class ___TABLE___CustomProgressBarDetail: UIView {

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
    let greyColor = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 1.0)

    override func draw(_ rect: CGRect) {
        let backgroundPath = UIBezierPath()
        backgroundPath.move(to: CGPoint(x: 0, y: self.frame.height/2))
        backgroundPath.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height/2))
        let backShapelayer = CAShapeLayer()
        backShapelayer.path = backgroundPath.cgPath
        backShapelayer.strokeColor = greyColor.cgColor
        backShapelayer.lineWidth = self.frame.height
        self.layer.addSublayer(backShapelayer)
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: self.frame.height/2))
        path.addLine(to: CGPoint(x: (percent * self.frame.width) / 100, y: self.frame.height/2))
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
            print("")
        }
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = (percent * self.frame.width) / 100
        animation.duration = 10
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        shapeLayer.add(animation, forKey: "drawLineAnimation")
        self.layer.addSublayer(shapeLayer)
    }
}

class ___TABLE___DetailsForm: DetailsForm___DETAILFORMTYPE___, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var gestureView: UIView!
    @IBOutlet weak var scrollViewContent: UIView!
    @IBOutlet weak var firstBloc: UIView!
    @IBOutlet weak var secondBloc: UIView!
    @IBOutlet weak var thirdBloc: UIView!
    var record: ___TABLE___ {
        return super.record as! ___TABLE___
    }

    // MARK: Events
    override func onLoad() {
        scrollView.delegate = self
        self.scrollView.setNeedsLayout()
        self.scrollView.layoutIfNeeded()
        let centerOffsetX = (scrollView.contentSize.width - scrollView.frame.size.width) / 2
        let centerPoint = CGPoint(x: centerOffsetX, y: 0)
        scrollView.setContentOffset(centerPoint, animated: true)
        if Device().isPad {
            firstBloc.alpha = 1
            secondBloc.alpha = 1
            thirdBloc.alpha = 1
            scrollView.isUserInteractionEnabled = false
        }
        if Device().isPhone {
            firstBloc.alpha = 0.4
            secondBloc.alpha = 1
            thirdBloc.alpha = 0.4
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.respondToTapGesture))
            self.gestureView.addGestureRecognizer(tap)
            let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
            swipeRight.direction = UISwipeGestureRecognizer.Direction.right
            self.gestureView.addGestureRecognizer(swipeRight)
            let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
            swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
            self.gestureView.addGestureRecognizer(swipeLeft)
        }
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
    // swiftlint:disable:next function_body_length
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        let gap: CGFloat = 1
        let centerOffsetX = (scrollView.contentSize.width - scrollView.frame.size.width) / 2
        let scrollViewOffsetX = scrollView.contentOffset.x
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case .right:
                scrollView.panGestureRecognizer.isEnabled = true
                if centerOffsetX > (scrollViewOffsetX + gap) {
                    let offSet = (scrollView.contentSize.width - scrollView.frame.size.width)
                    let centerPoint = CGPoint(x: offSet, y: 0)
                    scrollView.setContentOffset(centerPoint, animated: true)
                    firstBloc.blocFadeOut()
                    secondBloc.blocFadeOut()
                    thirdBloc.blocFadeIn()
                    self.scrollViewContent.shakeright()
                } else if centerOffsetX < (scrollViewOffsetX - gap) {
                    let offSet = (scrollView.contentSize.width - scrollView.frame.size.width)/2
                    let centerPoint = CGPoint(x: offSet, y: 0)
                    scrollView.setContentOffset(centerPoint, animated: true)
                    firstBloc.blocFadeOut()
                    secondBloc.blocFadeIn()
                    thirdBloc.blocFadeOut()
                    self.scrollViewContent.shakeright()
                } else {
                    scrollView.setContentOffset(.zero, animated: true)
                    firstBloc.blocFadeIn()
                    secondBloc.blocFadeOut()
                    thirdBloc.blocFadeOut()
                    self.scrollViewContent.shakeright()
                }
            case  .left:
                scrollView.panGestureRecognizer.isEnabled = true
                if centerOffsetX > (scrollViewOffsetX + gap) {
                    let offSet = (scrollView.contentSize.width - scrollView.frame.size.width)/2
                    let centerPoint = CGPoint(x: offSet, y: 0)
                    scrollView.setContentOffset(centerPoint, animated: true)
                    firstBloc.blocFadeOut()
                    secondBloc.blocFadeIn()
                    thirdBloc.blocFadeOut()
                    self.scrollViewContent.shakeleft()
                } else if centerOffsetX < (scrollViewOffsetX - gap) {
                    let centerPoint = CGPoint(x: 0, y: 0)
                    scrollView.setContentOffset(centerPoint, animated: true)
                    firstBloc.blocFadeIn()
                    secondBloc.blocFadeOut()
                    thirdBloc.blocFadeOut()
                    self.scrollViewContent.shakeleft()
                } else {
                    let offSet = (scrollView.contentSize.width - scrollView.frame.size.width)
                    let centerPoint = CGPoint(x: offSet, y: 0)
                    scrollView.setContentOffset(centerPoint, animated: true)
                    firstBloc.blocFadeOut()
                    secondBloc.blocFadeOut()
                    thirdBloc.blocFadeIn()
                    self.scrollViewContent.shakeleft()
                }
            default:
                break
            }
        }
    }
    // swiftlint:disable:next function_body_length
    @objc func respondToTapGesture(sender: UITapGestureRecognizer) {
        let gap: CGFloat = 1
        let centerOffsetX = (scrollView.contentSize.width - scrollView.frame.size.width) / 2
        let scrollViewOffsetX = scrollView.contentOffset.x
        if sender.state == .ended {
            let touchLocation: CGPoint = sender.location(in: sender.view)
            let position = touchLocation.x
            if position < centerOffsetX - 20 {
                scrollView.panGestureRecognizer.isEnabled = true
                if centerOffsetX > (scrollViewOffsetX + gap) {
                    let offSet = (scrollView.contentSize.width - scrollView.frame.size.width)
                    let centerPoint = CGPoint(x: offSet, y: 0)
                    scrollView.setContentOffset(centerPoint, animated: true)
                    firstBloc.blocFadeOut()
                    secondBloc.blocFadeOut()
                    thirdBloc.blocFadeIn()
                    self.scrollViewContent.shakeright()
                } else if centerOffsetX < (scrollViewOffsetX - gap) {
                    let offSet = (scrollView.contentSize.width - scrollView.frame.size.width)/2
                    let centerPoint = CGPoint(x: offSet, y: 0)
                    scrollView.setContentOffset(centerPoint, animated: true)
                    firstBloc.blocFadeOut()
                    secondBloc.blocFadeIn()
                    thirdBloc.blocFadeOut()
                    self.scrollViewContent.shakeright()
                } else {
                    scrollView.setContentOffset(.zero, animated: true)
                    firstBloc.blocFadeIn()
                    secondBloc.blocFadeOut()
                    thirdBloc.blocFadeOut()
                    self.scrollViewContent.shakeright()}
            } else if position > centerOffsetX + 20 {
                scrollView.panGestureRecognizer.isEnabled = true
                if centerOffsetX > (scrollViewOffsetX + gap) {
                    let offSet = (scrollView.contentSize.width - scrollView.frame.size.width)/2
                    let centerPoint = CGPoint(x: offSet, y: 0)
                    scrollView.setContentOffset(centerPoint, animated: true)
                    firstBloc.blocFadeOut()
                    secondBloc.blocFadeIn()
                    thirdBloc.blocFadeOut()
                    self.scrollViewContent.shakeleft()
                } else if centerOffsetX < (scrollViewOffsetX - gap) {
                    let centerPoint = CGPoint(x: 0, y: 0)
                    scrollView.setContentOffset(centerPoint, animated: true)
                    firstBloc.blocFadeIn()
                    secondBloc.blocFadeOut()
                    thirdBloc.blocFadeOut()
                    self.scrollViewContent.shakeleft()
                } else {
                    let offSet = (scrollView.contentSize.width - scrollView.frame.size.width)
                    let centerPoint = CGPoint(x: offSet, y: 0)
                    scrollView.setContentOffset(centerPoint, animated: true)
                    firstBloc.blocFadeOut()
                    secondBloc.blocFadeOut()
                    thirdBloc.blocFadeIn()
                    self.scrollViewContent.shakeleft()}
            }
        }
    }
}

private extension UIView {
    func shakeright() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.2
        animation.repeatCount = 1
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 40, y: self.center.y))
        self.layer.add(animation, forKey: "position")
    }
    func shakeleft() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.2
        animation.repeatCount = 1
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x - 40, y: self.center.y))
        self.layer.add(animation, forKey: "position")
    }
    func blocFadeOut(duration: TimeInterval = 0.4) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0.4
        })
    }
    func blocFadeIn(duration: TimeInterval = 0.4) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1
        })
    }
}
