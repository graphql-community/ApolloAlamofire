//
//  ExampleTests.swift
//  ExampleTests
//
//  Created by Max Desiatov on 05/04/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

@testable import ApolloAlamofire
import XCTest

class ExampleTests: XCTestCase {
  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  func testExample() {
    let u = URL(string: "http://google.com")!
    let transport = AlamofireTransport(url: u)
    XCTAssertEqual(u, transport.url)
    XCTAssertNil(transport.headers)
    XCTAssertFalse(transport.loggingEnabled)
    transport.headers = [:]
    XCTAssertEqual(transport.headers, [:])
    transport.loggingEnabled = true
    XCTAssertTrue(transport.loggingEnabled)
  }
}
