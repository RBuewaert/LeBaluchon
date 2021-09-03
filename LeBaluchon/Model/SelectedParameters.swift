//
//  CurrentParameters.swift
//  LeBaluchon
//
//  Created by Romain Buewaert on 26/08/2021.
//

import Foundation

final class SelectedParameters {
    static var selectedCurrency = Currency(currencyToConvert: "EUR", currencyToObtain: "USD", exchangeRate: [:])
    static var selectedWeatherLeftCity = Weather(city: "", hour: "", description: "", icon: "",
                                                 temperature: 0, feltTemperature: 0, pressure: 0,
                                                 humidity: 0, windSpeed: 0, cloudiness: 0, id: 0)
    static var selectedWeatherRightCity = selectedWeatherLeftCity
    static var firstSelectedId = 3034170
    static var secondSelectedId = 5128581
    static var selectedId: String {
        return String(firstSelectedId) + "," + String(secondSelectedId)
    }
    static var selectedLanguageToTranslate = "fr"
    static var selectedLanguageToObtain = "en"
    static var selectedTranslation = Translation(languageToTranslate: selectedLanguageToTranslate,
                                                 languageToObtain: selectedLanguageToObtain,
                                                 textToTranslate: "Bonjour", textToObtain: "Hello")
}
