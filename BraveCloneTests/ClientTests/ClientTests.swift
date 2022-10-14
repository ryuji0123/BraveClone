//
//  ClientTests.swift
//  BraveCloneTests
//
//  Created by ryo on 2022/10/12.
//

import XCTest
import GCDWebServer

class ClientTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        
        let server = WebServer.shared
        guard !server.server.isRunning else { return }
        
        // Need to add handlers before starting the server
        server.registerHandlerForTestMethods() {(request: GCDWebServerRequest?) -> GCDWebServerResponse? in
            return GCDWebServerDataResponse(html: "<html><body>Health Check works fine</body></html>")
        }
        
        do {
            try server.start()
        } catch let err as NSError {
            print("Error: Unable to start WebServer \(err)")
        }
        
    }
    
    func testDisallowedLocalhostAliases() throws {
        [
            "localhost",
            "",
            "127.0.0.1",
        ].forEach{ XCTAssert(isValidHost($0), "\($0) host should be valid.") }
        
        // Disabled local hosts. WKWebVuew will direct them to our server, but the server should reject them
        [
            "[::1]",
            "2130706433",
            "0",
            "127.00.00.01",
            "017700000001",
            "0x7f.0x0.0x0.0x1",
        ].forEach{ XCTAssertFalse(isValidHost($0), "\($0) host should not be valid.") }
    }
    
    fileprivate func isValidHost(_ host: String) -> Bool {
        let expectation = self.expectation(description: "Validate host for \(host)")
        let server = WebServer.shared
        let port = server.port
        
        var request = URLRequest(url: URL(string: "http://\(host):\(port)/health")!)
        var response: HTTPURLResponse?
        
        let username = server.credentials.user ?? ""
        let password = server.credentials.password ?? ""
        
        let credentials = "\(username):\(password)".data(using: .utf8)?.base64EncodedString() ?? ""
        
        request.setValue("Basic \(credentials)", forHTTPHeaderField: "Authorization")
        
        URLSession(configuration: .ephemeral, delegate: nil, delegateQueue: .main).dataTask(with: request) { data, resp, error in
            response = resp as? HTTPURLResponse
            expectation.fulfill()
        }.resume()
        
        waitForExpectations(timeout: 200, handler: nil)
        return response?.statusCode == 200
    }
}
