//
//  WebServer.swift
//  frontend
//
//  Created by ryo on 2022/09/10.
//

import Foundation
import GCDWebServer

protocol WebServerProtocol {
    var server: GCDWebServer { get }
    @discardableResult func start() throws -> Bool
}

class WebServer: WebServerProtocol {
    
    static let sharedInstance = WebServer()
    
    class var shared: WebServer {
        return sharedInstance
    }
    
    let credentials: URLCredential
    
    let port = AppConstants.webServerPort
    
    public let server: GCDWebServer = GCDWebServer()
    
    fileprivate let sessionToken = UUID().uuidString
    
    init() {
        credentials = URLCredential(user: sessionToken, password: "", persistence: .forSession)
    }
    
    func start() throws -> Bool {
        if !server.isRunning {
            try server.start(options: [
                GCDWebServerOption_Port: port,
                GCDWebServerOption_BindToLocalhost: true,
                GCDWebServerOption_AutomaticallySuspendInBackground: false, // TODO: done by the app in AppDelegate
                GCDWebServerOption_AuthenticationMethod: GCDWebServerAuthenticationMethod_Basic,
                GCDWebServerOption_AuthenticationAccounts: [sessionToken: ""],
            ])
        }
        return server.isRunning
    }
    
    public func registerHandlerForTestMethods(handler: @escaping (_ request: GCDWebServerRequest?) -> GCDWebServerResponse?) {
        let wrappedHandler = { (request: GCDWebServerRequest?) -> GCDWebServerResponse? in
          guard let request = request, InternalURL.isValid(url: request.url) else {
            return GCDWebServerResponse(statusCode: 403)
          }

          return handler(request)
        }
        server.addHandler(forMethod: "GET", path: "/health", request: GCDWebServerRequest.self, processBlock: wrappedHandler)
    }
}
