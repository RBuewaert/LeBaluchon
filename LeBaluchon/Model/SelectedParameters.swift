//
//  CurrentParameters.swift
//  LeBaluchon
//
//  Created by Romain Buewaert on 26/08/2021.
//

import Foundation

var selectedCurrency = Currency(currencyToConvert: "EUR", currencyToObtain: "USD", exchangeRate: [:])

var selectedWeatherLeftCity = Weather(city: "", hour: "", description: "", icon: "", temperature: 0, feltTemperature: 0, pressure: 0, humidity: 0, windSpeed: 0, cloudiness: 0)
var selectedWeatherRightCity = selectedWeatherLeftCity

var firstSelectedId = 3034170
var secondSelectedId = 5128581
var selectedId = "\(firstSelectedId),\(secondSelectedId)"

var selectedTranslation = Translation(languageToTranslate: "fr", languageToObtain: "en", textToTranslate: "Bonjour", textToObtain: "Hello")
