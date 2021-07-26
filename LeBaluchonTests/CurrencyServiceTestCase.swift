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
        let currencyService = CurrencyService(currencySession: URLSessionFake(data: nil, response: nil, error: FakeResponseData.error))

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

}
