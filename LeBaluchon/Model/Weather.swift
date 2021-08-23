//
//  Weather.swift
//  LeBaluchon
//
//  Created by Romain Buewaert on 27/07/2021.
//

import Foundation

// MARK: - Weather
struct Weather {
    var city: String
    var description: String
//    var weatherDescription: String (faire directement dans weather)
    var icon: String
    var temperature: Double
    var feltTemperature: Double
    var temperatureMin: Double
    var temperatureMax: Double
    var pressure: Int
    var humidity: Int
    var windSpeed: Double
    var cloudiness: Int
}

// MARK: - WeatherResult extracted from JSON

struct WeatherResult: Codable {
    let cnt: Int
    let list: [WeatherResultList]
}

struct WeatherResultList: Codable {
    let weather: [WeatherResultWeather]
    let main: WeatherResultMain
    let wind: WeatherResultWind
    let clouds: WeatherResultClouds
    let name: String
}

struct WeatherResultWeather: Codable {
    let description: String
    let icon: String
}

struct WeatherResultMain: Codable {
    let temp: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
    let pressure: Int
    let humidity: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
    }
}

struct WeatherResultWind: Codable {
    let speed: Double
}

struct WeatherResultClouds: Codable {
    let all: Int
}
