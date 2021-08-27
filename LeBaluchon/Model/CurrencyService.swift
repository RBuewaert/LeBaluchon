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
    private init() {}

    // MARK: - Dependency injection
    private var task: URLSessionDataTask?
    private var currencySession = URLSession(configuration: .default)

    init(currencySession: URLSession) {
        self.currencySession = currencySession
    }

    var requestSuccess = false

    private static let baseCurrencyUrl = "http://data.fixer.io/api/latest?access_key="

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

        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = SelectedParameters.selectedCurrency.currencyToObtain
        formatter.maximumFractionDigits = 2

        let formatterResult = NSNumber(value: result)
        return formatter.string(from: formatterResult)

//        return String(result)
    }

        /*
        a= 1 euro = >c= 10.57 dirham maroc
        b= 1 euro => d= 1.18 (1dirham : x= 0.11) dolar
         
         
         d/c = 0.11
         
         
         a= 1 euro => c= 1.18 dollar americain
         b= 1 euro => d= 359.22 (1dollar : x= 304.97) florin
          
          
          d/c = 304.423
          
         
         a= 1 euro => c= 359.26 florin
         b= 1 euro => d= 11249,25 (1florin : x= 31.32) kip laotien
        
          
          d/c = 31.3122
          
         
         
         
        */
}
