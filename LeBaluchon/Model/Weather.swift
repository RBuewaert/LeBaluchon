//
//  Weather.swift
//  LeBaluchon
//
//  Created by Romain Buewaert on 27/07/2021.
//

import Foundation

struct Weather {
    var city: String
    var weather: String
    var weatherDescription: String
    var icon: String
    var temperature: Double
    var feltTemperature: Double
    var temperatureMin: Double
    var temperatureMax: Double
    var Pressure: Int
    var humidity: Int
    var windSpeed: Double
    var cloudiness: Int
}

struct WeatherResult: Codable {
//    var coord: [String: Double]
    var weather: [String: String]
//    var base: String
    var main: [String: Double]
//    var visibility: Int
    var wind: [String: Double]
    var clouds: [String: Double]
//    var dt: Int
//    var sys: [String: String]
//    var timezone: Double
//    var id : Int
    var name: String
//    var cod: Int

    /*
    {
        "coord": {
            "lon": -74.006,
            "lat": 40.7143
        },
        "weather": [
            {
                "id": 800,
                "main": "Clear",
                "description": "clear sky",
                "icon": "01d"
            }
        ],
        "base": "stations",
        "main": {
            "temp": 23.96,
            "feels_like": 24.24,
            "temp_min": 20.82,
            "temp_max": 26.19,
            "pressure": 1014,
            "humidity": 70
        },
        "visibility": 10000,
        "wind": {
            "speed": 0,
            "deg": 0
        },
        "clouds": {
            "all": 1
        },
        "dt": 1627386664,
        "sys": {
            "type": 2,
            "id": 2039034,
            "country": "US",
            "sunrise": 1627379286,
            "sunset": 1627431402
        },
        "timezone": -14400,
        "id": 5128581,
        "name": "New York",
        "cod": 200
    }
 */
}
