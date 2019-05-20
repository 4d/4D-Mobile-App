//
//  Logger.swift
//  ___PACKAGENAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___
//  ___COPYRIGHT___

import Foundation
import XCGLogger

let logger = XCGLogger.forClass(AppDelegate.self)

func logEvent(_ message: @autoclosure @escaping () -> Any?, _ importance: XCGLogger.Level, functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line, userInfo: [String: Any] = [:]) {
    logger.log(importance, message(), functionName: functionName, fileName: fileName, lineNumber: lineNumber, userInfo: userInfo)
}
