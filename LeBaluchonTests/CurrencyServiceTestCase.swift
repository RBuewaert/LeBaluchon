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
        // COMPLETER LES DATAS !!!!!
        let currencyService = CurrencyService(currencySession: URLSessionFake(
                                                data: FakeResponseData.currencyCorrectData,
                                                response: FakeResponseData.responseOK, error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        currencyService.getExchangeRate { (success, currency) in
            // Then
            let exchangeRateUSD = ["USD": 1.179419]

            XCTAssertEqual(exchangeRateUSD["USD"], currency!.exchangeRate["USD"])
            XCTAssertTrue(success)
            XCTAssertNotNil(currency)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    func testConvertCurrencyShouldFailedIfThereIsUserValueEntered() {
        // Given
        let currency = Currency(exchangeRate: ["USD": 1.179419])

        // When
        // Then
        XCTAssertThrowsError(try CurrencyService.shared.convertCurrency(
                                        currency: currency,
                                        currencyToConvert: currency.currencyToConvert,
                                        currencyToObtain: currency.currencyToObtain,
                                        valueToConvert: nil)!) { (errorThrown) in
               XCTAssertEqual(errorThrown as? ErrorType, ErrorType.userValueIsIncorrect)
        }
    }

    func testConvertCurrencyShouldFailedIfTheUserValueEnteredIsNotADouble() {
        // Given
        let currency = Currency(exchangeRate: ["USD": 1.179419])

        // When
        // Then
        XCTAssertThrowsError(try CurrencyService.shared.convertCurrency(
                                        currency: currency,
                                        currencyToConvert: currency.currencyToConvert,
                                        currencyToObtain: currency.currencyToObtain,
                                valueToConvert: "15.5.5")!) { (errorThrown) in
               XCTAssertEqual(errorThrown as? ErrorType, ErrorType.userValueIsIncorrect)
        }
    }

    func testConvertCurrencyShouldFailedIfTheFirstCurrencyNotFound() {
        // Given
        let currency = Currency(exchangeRate: ["FRF": 1, "USD": 1.179419])

        // When
        // Then
        XCTAssertThrowsError(try CurrencyService.shared.convertCurrency(
                                        currency: currency,
                                        currencyToConvert: currency.currencyToConvert,
                                        currencyToObtain: currency.currencyToObtain,
                                valueToConvert: "15.5")!) { (errorThrown) in
               XCTAssertEqual(errorThrown as? ErrorType, ErrorType.firstCurrencyIsIncorrect)
        }
    }

    func testConvertCurrencyShouldFailedIfTheSecondCurrencyNotFound() {
        // Given
        let currency = Currency(exchangeRate: ["EUR": 1, "FRF": 1.179419])

        // When
        // Then
        XCTAssertThrowsError(try CurrencyService.shared.convertCurrency(
                                        currency: currency,
                                        currencyToConvert: currency.currencyToConvert,
                                        currencyToObtain: currency.currencyToObtain,
                                valueToConvert: "15.5")!) { (errorThrown) in
               XCTAssertEqual(errorThrown as? ErrorType, ErrorType.secondCurrencyIsIncorrect)
        }
    }

    func testConvertCurrencyShouldSuccesIfValueAndCurrenciesAreCorrect() {
        // Given
        let currency = Currency(exchangeRate: ["EUR": 1, "USD": 1.179419])

        // When
        // Then
        XCTAssertNoThrow(try CurrencyService.shared.convertCurrency(
                                        currency: currency,
                                        currencyToConvert: currency.currencyToConvert,
                                        currencyToObtain: currency.currencyToObtain,
                                valueToConvert: "15.5")!)
    }
}
