//
//  AboutCanadaTests.swift
//  AboutCanadaTests
//
//  Created by Ashish Tripathi on 16/02/20.
//  Copyright © 2020 Ashish Tripathi. All rights reserved.
//

@testable import AboutCanada
import XCTest

class AboutCanadaTests: XCTestCase {
    var factsList: Facts?

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: "Facts", withExtension: "json"),
            let data = try? Data(contentsOf: url) else {
            return
        }

        let decoder = JSONDecoder()
        factsList = try? decoder.decode(Facts.self, from: data)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testProductionServiceRunning() {
        // Put the code you want to measure the time of here.
        setUp()
        let expectation = self.expectation(description: "Get Facts abouts Canada's service is failed and we don't receive correct response")
        Networking.fetchFactsAboutCanada { result in
            switch result {
            case let .success(data):
                XCTAssertNotNil(data)
                expectation.fulfill()
            default:
                XCTFail("Expected get facts service response with error json")
            }
        }
        waitForExpectations(timeout: 6.0)
    }

    func testServiceError() {
        let expectation = self.expectation(description: "Looks like, latest facts is not on the top")
        Networking.fetchFactsAboutCanada(shouldFail: true) { result in
            switch result {
            case let .failure(error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            default:
                XCTFail("Expected get facts service response with error json")
            }
        }
        waitForExpectations(timeout: 6.0)
    }

    func testFactsTitle() {
        XCTAssertEqual(factsList?.title, "About Canada")
    }

    func testImageUrlShoudNotBeNil() {
        XCTAssertNotNil(factsList?.rows?.first?.imageHref)
    }

    func testImageIsDownloaded() {
        let expectation = self.expectation(description: "Image should be download")
        guard let imageUrl = factsList?.rows?.first?.imageHref else {
            XCTFail("failed to get url")
            return
        }
        Networking.downloadImage(url: URL(fileURLWithPath: imageUrl)) { data in
            XCTAssertNotNil(data)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 6.0)
    }
}
