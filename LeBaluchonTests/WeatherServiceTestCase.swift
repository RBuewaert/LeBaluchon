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
            let weather1City = "Beaumont-de-Lomagne"
            let weather2City = "New York"
            let weather1Description = "broken clouds"
            let weather2Description = "moderate rain"
            let weather1Icon = "04d"
            let weather1Temperature = 19.2
            let weather2Temperature = 22.4
            let weather2FeltTemperature = 23.2
            let weather2Pressure = 1007
            let weather1Humidity = 61
            let weather1Wind = 10.0
            let weather2Wind = 2.0
            let weather1Cloud = 84
            let weather1Id = 3034170
            let weather2Id = 5128581

            XCTAssertEqual(weather1City, weather1!.city)
            XCTAssertEqual(weather1Description, weather1!.description)
            XCTAssertEqual(weather1Icon, weather1!.icon)
            XCTAssertEqual(weather1Temperature, weather1!.temperature)
            XCTAssertEqual(weather1Humidity, weather1!.humidity)
            XCTAssertEqual(weather1Wind, weather1!.windSpeed)
            XCTAssertEqual(weather1Cloud, weather1!.cloudiness)
            XCTAssertEqual(weather1Id, weather1!.id)

            XCTAssertEqual(weather2City, weather2!.city)
            XCTAssertEqual(weather2Description, weather2!.description)
            XCTAssertEqual(weather2Temperature, weather2!.temperature)
            XCTAssertEqual(weather2FeltTemperature, weather2!.feltTemperature)
            XCTAssertEqual(weather2Pressure, weather2!.pressure)
            XCTAssertEqual(weather2Wind, weather2!.windSpeed)
            XCTAssertEqual(weather2Id, weather2!.id)

            XCTAssertTrue(success)
            XCTAssertNotNil(weather1)
            XCTAssertNotNil(weather2)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
}
