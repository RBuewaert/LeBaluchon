//
//  TranslationServiceTestCase.swift
//  LeBaluchonTests
//
//  Created by Romain Buewaert on 27/08/2021.
//

import XCTest
@testable import LeBaluchon

class TranslationServiceTestCase: XCTestCase {
    // MARK: - Method getTranslation
    func testGetTranslationShouldPostFailedCallbackIfError() {
        // Given
        let translationService = TranslationService(translationSession: URLSessionFake(
                                                data: nil, response: nil, error: FakeResponseData.error))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translationService.getTranslation(textToTranslate: "Bonjour, mon nom est Bond!",
                        languageToTranslate: "fr", languageToObtain: "en") { (success, translation) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(translation)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetTranslationShouldPostFailedCallbackIfNoData() {
        // Given
        let translationService = TranslationService(translationSession: URLSessionFake(
                                                data: nil, response: nil, error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translationService.getTranslation(textToTranslate: "Bonjour, mon nom est Bond!",
                        languageToTranslate: "fr", languageToObtain: "en") { (success, translation) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(translation)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetTranslationShouldPostFailedCallbackIfIncorrectResponse() {
        let translationService = TranslationService(translationSession: URLSessionFake(
                                                data: FakeResponseData.translationCorrectData,
                                                response: FakeResponseData.responseKO, error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translationService.getTranslation(textToTranslate: "Bonjour, mon nom est Bond!",
                        languageToTranslate: "fr", languageToObtain: "en") { (success, translation) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(translation)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetTranslationShouldPostFailedCallbackIfIncorrectData() {
        let translationService = TranslationService(translationSession: URLSessionFake(
                                                data: FakeResponseData.incorrectData,
                                                response: FakeResponseData.responseOK, error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translationService.getTranslation(textToTranslate: "Bonjour, mon nom est Bond!",
                        languageToTranslate: "fr", languageToObtain: "en") { (success, translation) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(translation)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetTranslationShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        let translationService = TranslationService(translationSession: URLSessionFake(
                                                data: FakeResponseData.translationCorrectData,
                                                response: FakeResponseData.responseOK, error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translationService.getTranslation(textToTranslate: "Bonjour, mon nom est Bond!",
                        languageToTranslate: "fr", languageToObtain: "en") { (success, translation) in
            // Then
            let translatedText = "Hello, my name is Bond!"

            XCTAssertEqual(translatedText, translation!.textToObtain)
            XCTAssertTrue(success)
            XCTAssertNotNil(translation)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
}
