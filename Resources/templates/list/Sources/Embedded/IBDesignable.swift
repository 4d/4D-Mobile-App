//
//  ListForm.swift
//  ___PACKAGENAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___
//  ___COPYRIGHT___

import Foundation
import QMobileUI

// Here temporary code to fix apple bug on @IBDesignable object precompiled in framework

@IBDesignable
class ListFormTable: QMobileUI.ListFormTable {

    @IBInspectable open override var sectionFieldname: String? {
        get {
            return super.sectionFieldname
        }
        set {
            super.sectionFieldname = newValue
        }
    }

    @IBInspectable open override var sectionFieldFormatter: String? {
        get {
            return super.sectionFieldFormatter
        }
        set {
            super.sectionFieldFormatter = newValue
        }
    }

    @IBInspectable open override var selectedSegueIdentifier: String {
        get {
            return super.selectedSegueIdentifier
        }
        set {
            super.selectedSegueIdentifier = newValue
        }
    }

    @IBInspectable open override var searchableField: String {
        get {
            return super.searchableField
        }
        set {
            super.searchableField = newValue
        }
    }

    /// Add search bar in place of navigation bar title
    @IBInspectable open override var searchableAsTitle: Bool {
        get {
            return super.searchableAsTitle
        }
        set {
            super.searchableAsTitle = newValue
        }
    }

    /// Keep search bar if scrolling
    @IBInspectable open override var searchableWhenScrolling: Bool {
        get {
            return super.searchableWhenScrolling
        }
        set {
            super.searchableWhenScrolling = newValue
        }
    }

    /// Hide navigation bar when searching
    @IBInspectable open override var searchableHideNavigation: Bool {
        get {
            return super.searchableHideNavigation
        }
        set {
            super.searchableHideNavigation = newValue
        }
    }

    @IBOutlet open override var searchBar: UISearchBar! {
        get {
            return super.searchBar
        }
        set {
            super.searchBar = newValue
        }
    }

    @IBInspectable open override var showSectionBar: Bool {
        get {
            return super.showSectionBar
        }
        set {
            super.showSectionBar = newValue
        }
    }
}

@IBDesignable
class ListFormCollection: QMobileUI.ListFormCollection {

    @IBInspectable open override var sectionFieldname: String? {
        get {
            return super.sectionFieldname
        }
        set {
            super.sectionFieldname = newValue
        }
    }

    @IBInspectable open override var sectionFieldFormatter: String? {
        get {
            return super.sectionFieldFormatter
        }
        set {
            super.sectionFieldFormatter = newValue
        }
    }

    @IBInspectable open override var selectedSegueIdentifier: String {
        get {
            return super.selectedSegueIdentifier
        }
        set {
            super.selectedSegueIdentifier = newValue
        }
    }

    @IBInspectable open override var searchableField: String {
        get {
            return super.searchableField
        }
        set {
            super.searchableField = newValue
        }
    }

    /// Add search bar in place of navigation bar title
    @IBInspectable open override var searchableAsTitle: Bool {
        get {
            return super.searchableAsTitle
        }
        set {
            super.searchableAsTitle = newValue
        }
    }

    /// Keep search bar if scrolling
    @IBInspectable open override var searchableWhenScrolling: Bool {
        get {
            return super.searchableWhenScrolling
        }
        set {
            super.searchableWhenScrolling = newValue
        }
    }

    /// Hide navigation bar when searching
    @IBInspectable open override var searchableHideNavigation: Bool {
        get {
            return super.searchableHideNavigation
        }
        set {
            super.searchableHideNavigation = newValue
        }
    }

    @IBOutlet open override var searchBar: UISearchBar! {
        get {
            return super.searchBar
        }
        set {
            super.searchBar = newValue
        }
    }

    @IBInspectable open override var showSectionBar: Bool {
        get {
            return super.showSectionBar
        }
        set {
            super.showSectionBar = newValue
        }
    }
}

@IBDesignable
class DetailsFormBare: QMobileUI.DetailsFormBare {

    @IBInspectable open override var hasSwipeGestureRecognizer: Bool {
        get {
            return super.hasSwipeGestureRecognizer
        }
        set {
            super.hasSwipeGestureRecognizer = newValue
        }
    }

    @IBAction open override func nextRecord(_ sender: Any!) {
        super.nextRecord(sender)
    }

    @IBAction open override func previousRecord(_ sender: Any!) {
        super.previousRecord(sender)
    }
}

@IBDesignable
class DetailsFormTable: QMobileUI.DetailsFormTable {

    @IBInspectable open override var hasSwipeGestureRecognizer: Bool {
        get {
            return super.hasSwipeGestureRecognizer
        }
        set {
            super.hasSwipeGestureRecognizer = newValue
        }
    }

    @IBAction open override func nextRecord(_ sender: Any!) {
        super.nextRecord(sender)
    }

    @IBAction open override func previousRecord(_ sender: Any!) {
        super.previousRecord(sender)
    }
}

class DialogForm: QMobileUI.DialogForm {

    @IBInspectable open override var okMessage: String? {
        get {
            return super.okMessage
        }
        set {
            super.okMessage = newValue
        }
    }
    @IBInspectable open override var cancelMessage: String? {
        get {
            return super.cancelMessage
        }
        set {
            super.cancelMessage = newValue
        }
    }
}

extension UILabel {

    open override var bindTo: Binder {
        return super.bindTo
    }

}

@IBDesignable
open class IconLabel: QMobileUI.IconLabel {
}

@IBDesignable
open class LoadingButton: QMobileUI.LoadingButton {
}

#if DEBUG
    class DetailsForm___DETAILFORMTYPE___: DetailsFormBare {}
    class ListForm___LISTFORMTYPE___: ListFormTable {}
#endif
