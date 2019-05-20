//
//  ___TABLE___ListForm.swift
//  ___PACKAGENAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___
//  ___COPYRIGHT___

import UIKit
import QMobileUI
import AnimatedCollectionViewLayout

/// Generated list form for ___TABLE___ table.
@IBDesignable
class ___TABLE___ListForm: ListFormCollection {

    var navigationBarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.size.height + (self.navigationController?.navigationBar.frame.height ?? 0.0)
    }

    // Do not edit name or override tableName
    public override var tableName: String {
        return "___TABLE___"
    }

    // MARK: Events
    override func onLoad() {
        // Do any additional setup after loading the view.
        collectionView?.isPagingEnabled = true
        updateLayoutAnimator()
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

    // MARK: - scroll

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let navigationBarHeight = self.navigationBarHeight
        if scrollView.contentOffset.y >= -navigationBarHeight {
            scrollView.contentOffset.y = -navigationBarHeight
        }
        if scrollView.contentOffset.x > 0, let originalBounds = refreshControl?.bounds {
            refreshControl?.bounds = originalBounds.with(x: -scrollView.contentOffset.x)
        }
    }

    // MARK: - animator

    @IBInspectable open var animator: String = "parallax" {
        didSet {
            self._animator = LayoutAttributesAnimatorType(string: self.animator)
        }
    }

    fileprivate var _animator: LayoutAttributesAnimatorType = .parallax {
        didSet {
            updateLayoutAnimator()
        }
    }

    func updateLayoutAnimator() {
        if let layout = self.collectionView?.collectionViewLayout as? AnimatedCollectionViewLayout {
            layout.animator = _animator.animator
            layout.scrollDirection = .horizontal
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ___TABLE___ListForm: UICollectionViewDelegateFlowLayout {

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(Int16.max)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = self.view.frame.size
        if let tabBarController = tabBarController {
            size = CGSize(width: size.width,
                          height: size.height - tabBarController.tabBar.frame.size.height - navigationBarHeight)
        }
        return size
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

}

// MARK: - LayoutAttributesAnimatorType

private enum LayoutAttributesAnimatorType {
    case parallax
    case cube
    case linearCard
    case rotateInOut
    case page
    case crossFade
    case snapIn

    static let `default`: LayoutAttributesAnimatorType = .parallax
}

extension LayoutAttributesAnimatorType {

    init(string: String?) {
        guard let string = string else {
            self = .default
            return
        }
        let name = string.lowercased()
        switch name {
        case "parallax":
            self = .parallax
        case "cube":
            self = .cube
        case "linearcard":
            self = .linearCard
        case "rotateinout":
            self = .rotateInOut
        case "page":
            self = .page
        case "crossfade":
            self = .crossFade
        case "snapin":
            self = .snapIn
        default:
            assertionFailure("Unknown animator \(name)")
            self = .default
        }
    }

}

extension LayoutAttributesAnimatorType {
    var animator: LayoutAttributesAnimator {
        switch self {
        case .parallax:
            return ParallaxAttributesAnimator()
        case .cube:
            return CubeAttributesAnimator()
        case .linearCard:
            return LinearCardAttributesAnimator()
        case .rotateInOut:
            return RotateInOutAttributesAnimator()
        case .snapIn:
            return SnapInAttributesAnimator()
        case .page:
            return PageAttributesAnimator()
        case .crossFade:
            return CrossFadeAttributesAnimator()
        }
    }
}
