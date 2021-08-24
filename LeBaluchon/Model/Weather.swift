//
//  Weather.swift
//  LeBaluchon
//
//  Created by Romain Buewaert on 27/07/2021.
//

import Foundation

// MARK: - Struct for Weather
struct Weather {
    var city: String
    var hour: String
    var description: String
    var icon: String
    var temperature: Double
    var feltTemperature: Double
    var pressure: Int
    var humidity: Int
    var windSpeed: Double
    var cloudiness: Int
}

// MARK: - Struct result from JSON

struct WeatherResult: Codable {
    let cnt: Int
    let list: [WeatherResultList]
}

struct WeatherResultList: Codable {
    let sys : WeatherResultSys
    let weather: [WeatherResultWeather]
    let main: WeatherResultMain
    let wind: WeatherResultWind
    let clouds: WeatherResultClouds
    let name: String
}

struct WeatherResultSys: Codable {
    let timezone: Int
}

struct WeatherResultWeather: Codable {
    let description: String
    let icon: String
}

struct WeatherResultMain: Codable {
    let temp: Double
    let feelsLike: Double
    let pressure: Int
    let humidity: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case pressure, humidity
    }
}

struct WeatherResultWind: Codable {
    let speed: Double
}

struct WeatherResultClouds: Codable {
    let all: Int
}
