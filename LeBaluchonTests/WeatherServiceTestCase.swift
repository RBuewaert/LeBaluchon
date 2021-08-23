//
//  WeatherServiceTestCase.swift
//  LeBaluchonTests
//
//  Created by Romain Buewaert on 23/08/2021.
//

import XCTest
@testable import LeBaluchon

class WeatherServiceTestCase: XCTestCase {
    func testGetWeatherGroupShouldPostFailedCallbackIfError() {
        // Given
        let currencyService = WeatherService(weatherSession: URLSessionFake(
                                                data: nil, response: nil, error: FakeResponseData.error))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        currencyService.getWeatherGroup { (success, weather1, weather2) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(weather1)
            XCTAssertNil(weather2)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }
}
