//
//  URLExtensions.swift
//  BraveClone
//
//  Created by ryo on 2022/10/12.
//

import Foundation

public struct InternalURL {
    static func isValid(url: URL) -> Bool {
        let isWebServerUrl = url.absoluteString.hasPrefix("http://localhost:\(AppConstants.webServerPort)/") || url.absoluteString.hasPrefix("http://127.0.0.1:\(AppConstants.webServerPort)")
        return isWebServerUrl
    }
}
