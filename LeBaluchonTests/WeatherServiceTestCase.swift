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

    func testGetWeatherGroupShouldPostFailedCallbackIfNoData() {
        // Given
        let currencyService = WeatherService(weatherSession: URLSessionFake(
                                                data: nil, response: nil, error: nil))

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

    func testGetWeatherGroupShouldPostFailedCallbackIfIncorrectResponse() {
        // Given
        let currencyService = WeatherService(weatherSession: URLSessionFake(
                                                data: FakeResponseData.weatherGroupCorrectData,
                                                response: FakeResponseData.responseKO, error: nil))

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

    func testGetWeatherGroupShouldPostFailedCallbackIfIncorrectData() {
        // Given
        let currencyService = WeatherService(weatherSession: URLSessionFake(
                                                data: FakeResponseData.incorrectData,
                                                response: FakeResponseData.responseOK, error: nil))

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

    func testGetWeatherGroupShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        // Given
        let currencyService = WeatherService(weatherSession: URLSessionFake(
                                                data: FakeResponseData.weatherGroupCorrectData,
                                                response: FakeResponseData.responseOK, error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        currencyService.getWeatherGroup { (success, weather1, weather2) in
            // Then
            XCTAssertTrue(success)
            XCTAssertNotNil(weather1)
            XCTAssertNotNil(weather2)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }
}
