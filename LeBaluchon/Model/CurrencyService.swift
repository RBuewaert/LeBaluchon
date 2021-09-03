//
//  CurrencyService.swift
//  LeBaluchon
//
//  Created by Romain Buewaert on 26/07/2021.
//

import Foundation

final class CurrencyService {
    // MARK: - Pattern Singleton
    static var shared = CurrencyService()

    // MARK: - Dependency injection
    private var task: URLSessionDataTask?
    private var currencySession = URLSession(configuration: .default)

    init(currencySession: URLSession = URLSession.shared) {
        self.currencySession = currencySession
    }

    // MARK: - Property to check if request is in progress or already realised on ViewDidLoad Controller
    var requestSuccess = false

    // MARK: - Url
    private static let baseCurrencyUrl = "http://data.fixer.io/api/latest?access_key="

    // MARK: - Request
    func getExchangeRate(callback: @escaping (Bool, Currency?) -> Void ) {
        guard let url = URL(string: CurrencyService.baseCurrencyUrl + keyFixerIo) else {
            callback(false, nil)
            return
        }

        task?.cancel()
        task = currencySession.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    return callback(false, nil)
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    return callback(false, nil)
                }
                // Extract property indicated in Struct CurrencyResult
                guard let result = try? JSONDecoder().decode(CurrencyResult.self, from: data) else {
                    return callback(false, nil)
                }
                let currency = Currency(exchangeRate: result.rates)
                callback(true, currency)
            }
        }
        task?.resume()
    }

    // MARK: - Methods to check and convert user Value
    private func valueIsCorrect(userValue: String?) throws -> Double {
        guard let userValue: String = userValue else {
            print("Please enter a correct value")
            throw ErrorType.userValueIsIncorrect
        }
        guard let value = Double(userValue) else {
            print("Please enter a correct value")
            throw ErrorType.userValueIsIncorrect
        }
        return value
    }

    func convertCurrency(currency: Currency, currencyToConvert: String,
                         currencyToObtain: String, valueToConvert: String?) throws -> String? {
        let value = try valueIsCorrect(userValue: valueToConvert)
        guard let currencyToConvertValue = currency.exchangeRate[currencyToConvert] else {
            throw ErrorType.firstCurrencyIsIncorrect
        }
        guard let currencyToObtainValue = currency.exchangeRate[currencyToObtain] else {
            throw ErrorType.secondCurrencyIsIncorrect
        }

        let result = value * (currencyToObtainValue / currencyToConvertValue)

        return formatterCurrencyCode(value: result, currency: SelectedParameters.selectedCurrency.currencyToObtain)
    }

    func formatterCurrencyCode(value: Double, currency: String) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currency
        formatter.maximumFractionDigits = 2
        let formatterresult = NSNumber(value: value)
        return formatter.string(from: formatterresult)
    }
}
