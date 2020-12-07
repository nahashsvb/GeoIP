//
//  CheckIpInteractorTests.swift
//  GeoIPTests
//
//  Created by Serhii Borysov on 12/7/20.
//

import XCTest
@testable import GeoIP


class CheckIpInteractorTests: XCTestCase {
    var interactor: PresenterToInteractorProtocol!
    
    override func setUpWithError() throws {
        interactor = CheckIpInteractor()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInvalidInput() throws {
        let result = interactor.fetchIpDetails(query: "192.168...000.1111.some_other_input")
        XCTAssert(!result)
    }
    
    func testValidIpv4() throws {
        let result = interactor.fetchIpDetails(query: "8.8.8.8")
        XCTAssert(result)
    }
    
    func testInvalidIpv4() throws {
        let result = interactor.fetchIpDetails(query: "256.192.168.8")
        XCTAssert(!result)
    }
    
    func testValidIpv6() throws {
        let result = interactor.fetchIpDetails(query: "2001:0db8:85a3:0000:0000:8a2e:0370:7334")
        XCTAssert(result)
    }
    
    func testInvalidIpv6() throws {
        let result = interactor.fetchIpDetails(query: "2001009:0dbaa8:85adef3:0000:0000:8a2e:0370:7334")
        XCTAssert(result)
    }
    

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
    
