//
//  AppConstants.swift
//  BraveClone
//
//  Created by ryo on 2022/10/11.
//

import Foundation

public struct AppConstants {
    public static let isRunningTest = NSClassFromString("XCTestCase") != nil
    public static let webServerPort = 8080
}
