//
//  BreakingBadTests.swift
//  BreakingBadTests
//
//  Created by Thomas Woodfin on 1/12/21.
//  Copyright © 2021 Thomas Woodfin. All rights reserved.
//

import XCTest
@testable import BreakingBad

class BreakingBadTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        checkCharecterListMockData()
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    private func checkCharecterListMockData(){
        APIClient.shared.checkMockdata(fileName: "CharecterListResponse", modelType: CharecterResponse.self) { (response) in
            switch response {
            case .success(let model):
                XCTAssertNotNil(model.appearance)
                XCTAssertNotNil(model.birthday)
                XCTAssertNotNil(model.category)
                XCTAssertNotNil(model.charId)
                XCTAssertNotNil(model.description)
                XCTAssertNotNil(model.img)
                XCTAssertNotNil(model.name)
                XCTAssertNotNil(model.nickname)
            case .failure((let code, let data, let err)):
                print("code = \(code)")
                print("data = \(String(describing: data))")
                print("error = \(err.localizedDescription)")
            }
        }
    }

}
