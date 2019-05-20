//
//  Test.swift
//  ___PACKAGENAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___
//  ___COPYRIGHT___

import XCTest

class Test: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTabBarBrowsing() {
        let app = XCUIApplication()
        for i in 0...app.tabBars.buttons.count-2 {
            app.tabBars.buttons.element(boundBy: i).tap()
            //if the view is a collection
            let firstItemSelection = app.collectionViews.children(matching: .any).element(boundBy: 0)
            let navBar = app.navigationBars.element(boundBy: 0).children(matching: .button)
            if firstItemSelection.exists{
                firstItemSelection.tap()
                let nbItemInCollection = app.collectionViews.cells.count
                for _ in 0...nbItemInCollection {
                    if navBar.element(boundBy: 2).exists {
                        navBar.element(boundBy: 2).tap()
                    }
                }
                for _ in 0...nbItemInCollection {
                    navBar.element(boundBy: 1).tap()
                }
                navBar.element(boundBy: 0).tap()
            }
            //if the view is a table
            let firstItemSelectionTable = app.tables.cells.children(matching: .any).element(boundBy: 0)
            if firstItemSelectionTable.exists{
                firstItemSelectionTable.tap()
                let nbItemInTable = app.tables.cells.count
                for _ in 0...nbItemInTable {
                    if navBar.element(boundBy: 2).exists {
                        navBar.element(boundBy: 2).tap()
                    }
                }
                for _ in 0...nbItemInTable {
                    if navBar.element(boundBy: 1).exists {
                        navBar.element(boundBy: 1).tap()
                    }
                }
                navBar.element(boundBy: 0).tap()
            }
        }
    }
    // test More nail
    func testMoreTabBar(){
        let app = XCUIApplication()
        let btnMore = app.tabBars.buttons["More"]
        if btnMore.exists {
            btnMore.tap()
            let navBar = app.navigationBars.element(boundBy: 0).children(matching: .button)
            for i in 0...app.staticTexts.count-2 {
                app.staticTexts.element(boundBy: i).tap()
                //if the view is a collection
                let firstItemSelectionCollection = app.collectionViews.children(matching: .any).element(boundBy: 0)
                if firstItemSelectionCollection.exists{
                    firstItemSelectionCollection.tap()
                    let nbItemInCollection = app.collectionViews.cells.count
                    for _ in 0...nbItemInCollection {
                        navBar.element(boundBy: 2).tap()
                    }
                    for _ in 0...nbItemInCollection {
                        navBar.element(boundBy: 1).tap()
                    }
                    navBar.element(boundBy: 0).tap()
                }
                //if the view is a table
                let firstItemSelectionTable = app.tables.cells.children(matching: .any).element(boundBy: 0)
                if firstItemSelectionTable.exists{
                    firstItemSelectionTable.tap()
                    let nbItemInTable = app.tables.cells.count
                    for _ in 0...nbItemInTable {
                        navBar.element(boundBy: 2).tap()
                    }
                    for _ in 0...nbItemInTable {
                        navBar.element(boundBy: 1).tap()
                    }
                    navBar.element(boundBy: 0).tap()
                }
                navBar.element(boundBy: 0).tap()
            }
        }
    }
    
}
