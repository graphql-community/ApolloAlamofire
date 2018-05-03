import XCTest
@testable import ApolloAlamofire

class Tests: XCTestCase {
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
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
