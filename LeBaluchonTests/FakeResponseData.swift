//
//  FakeResponseData.swift
//  LeBaluchonTests
//
//  Created by Romain Buewaert on 26/07/2021.
//

import Foundation

class FakeResponseData {
    // MARK: - Data
        static var currencyCorrectData: Data? {
            let bundle = Bundle(for: FakeResponseData.self)
            let url = bundle.url(forResource: "Currency", withExtension: "json")!
            return try! Data(contentsOf: url)
        }

        static let currencyIncorrectData = "erreur".data(using: .utf8)!

//        static let imageData = "image".data(using: .utf8)!

        // MARK: - Response
        static let responseOK = HTTPURLResponse(
            url: URL(string: "https://openclassrooms.com")!,
            statusCode: 200, httpVersion: nil, headerFields: [:])!

        static let responseKO = HTTPURLResponse(
            url: URL(string: "https://openclassrooms.com")!,
            statusCode: 500, httpVersion: nil, headerFields: [:])!


        // MARK: - Error
        class CurrencyError: Error {}
        static let error = CurrencyError()
}
