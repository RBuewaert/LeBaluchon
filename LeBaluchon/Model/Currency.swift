//
//  Currency.swift
//  LeBaluchon
//
//  Created by Romain Buewaert on 26/07/2021.
//

import Foundation

// MARK: - Struct for Currency
struct Currency {
    var currencyToConvert = "EUR"
    var currencyToObtain = "USD"
    var exchangeRate: [String: Double]
}

// MARK: - Struct Result from JSON
struct CurrencyResult: Codable {
    var rates: [String: Double]
}
