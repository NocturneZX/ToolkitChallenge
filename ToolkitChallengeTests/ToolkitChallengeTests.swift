//
//  ToolkitChallengeTests.swift
//  ToolkitChallengeTests
//
//  Created by Julio Reyes on 3/9/23.
//

import XCTest
@testable import ToolkitChallenge

class ToolkitChallengeTests: XCTestCase {
    
    private var mockViewModel: MapViewViewModel! = nil

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.mockViewModel = MapViewViewModel()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.mockViewModel = nil
    }
    
    func testMapData() {
        let lat = 37.7749
        let lon = -122.4194
        let zoom = 12.0
        let type = "radar"
        
        mockViewModel.fetchMapData(latitude: lat, longitude: lon, zoom: zoom, type: type)
        
        XCTAssertNotNil(mockViewModel.mapTile)
    }
    
    func testStormReports() {
        let lat = 37.7749
        let lon = -122.4194
        
        mockViewModel.fetchStormReports(latitude: lat, longitude: lon)
        
        XCTAssertGreaterThan(mockViewModel.annotations.count, 0)
    }
    
    func testStormReportsWithInvaildLocation() {
        let lat = 0
        let lon = 0
        
        mockViewModel.fetchStormReports(latitude: Double(lat), longitude: Double(lon))
        
        XCTAssertEqual(mockViewModel.annotations.count, 0)
       // XCTAssertEqual(consoleOutput, "Error fetching storm reports: Max daily access is reached.")
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

