//
//  Swift_SauceNaoTests.swift
//  Swift-SauceNaoTests
//
//  Created by Isaac Lyons on 12/31/20.
//

import XCTest
@testable import Swift_SauceNao

class Swift_SauceNaoTests: XCTestCase {
    
    func testSearchString() {
        let expectation = XCTestExpectation(description: "Get sauce from URL string")
        saucenao.search(url: urlString) { result, error in
            if let error = error {
                XCTFail("\(error)")
            }
            
            guard let result = result else {
                XCTFail("No result.")
                return
            }
            
            guard let results = result.results else {
                XCTFail("No results. Ensure the provided image_url has results")
                return
            }
            
            XCTAssertGreaterThan(results.count, 0)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    private var saucenao: SauceNao {
        guard let key = ProcessInfo.processInfo.environment["api_key"] else {
            XCTFail("You need to set the api_key in the environment.")
            return SauceNao(apiKey: "")
        }
        return SauceNao(apiKey: key, testmode: true)
    }
    
    private var urlString: String {
        guard let urlString = ProcessInfo.processInfo.environment["image_url"] else {
            XCTFail("You need to set the image_url in the environment.")
            return ""
        }
        return urlString
    }
    
}
