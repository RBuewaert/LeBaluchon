//
//  CurrencyServiceTestCase.swift
//  LeBaluchonTests
//
//  Created by Romain Buewaert on 26/07/2021.
//

import XCTest
@testable import LeBaluchon

class CurrencyServiceTestCase: XCTestCase {
    func testGetExchangeRateShouldPostFailedCallbackIfError() {
        // Given
        let currencyService = CurrencyService(currencySession: URLSessionFake(
                                                data: nil, response: nil, error: FakeResponseData.error))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        currencyService.getExchangeRate { (success, currency) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(currency)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetExchangeRateShouldPostFailedCallbackIfNoData() {
        // Given
        let currencyService = CurrencyService(currencySession: URLSessionFake(data: nil, response: nil, error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        currencyService.getExchangeRate { (success, currency) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(currency)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetExchangeRateShouldPostFailedCallbackIfIncorrectResponse() {
        let currencyService = CurrencyService(currencySession: URLSessionFake(
                                                data: FakeResponseData.currencyCorrectData,
                                                response: FakeResponseData.responseKO, error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        currencyService.getExchangeRate { (success, currency) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(currency)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetExchangeRateShouldPostFailedCallbackIfIncorrectData() {
        let currencyService = CurrencyService(currencySession: URLSessionFake(
                                                data: FakeResponseData.incorrectData,
                                                response: FakeResponseData.responseOK, error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        currencyService.getExchangeRate { (success, currency) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(currency)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetExchangeRateShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        let currencyService = CurrencyService(currencySession: URLSessionFake(
                                                data: FakeResponseData.currencyCorrectData,
                                                response: FakeResponseData.responseOK, error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        currencyService.getExchangeRate { (success, currency) in
            // Then
            XCTAssertTrue(success)
            XCTAssertNotNil(currency)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }
}
