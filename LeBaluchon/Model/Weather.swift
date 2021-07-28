//
//  Weather.swift
//  LeBaluchon
//
//  Created by Romain Buewaert on 27/07/2021.
//

import Foundation

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
    var humidity: Double
    var windSpeed: Double
    var cloudiness: Double
    
    /* vitesste du vent par défaut metre par s :
    Une vitesse de 1 m/s correspond à 3,6 km/h soit 1,9 nœuds. Une vitesse de 25 m/s correspond à 90 km/h soit 49 nœuds. Une vitesse de 28 m/s correspond à 100 km/h soit 54 nœuds.
    */
}

struct WeatherResultList: Codable {
    var name: String
    var description: String
//    var weatherDescription: String (faire directement dans weather)
    var icon: String
    var temp: Double
    var feels_like: Double
    var temp_min: Double
    var temp_max: Double
    var pressure: Int
    var humidity: Int
    var speed: Double
    var all: Double
}



struct WeatherResult: Codable {
    let weather: [WeatherResultWeather]
    let main: WeatherResultMain
    let wind: WeatherResultWind
    let clouds: WeatherResultClouds
    let name: String
}

struct WeatherResultWeather: Codable {
    let main: String
    let description: String
    let icon: String
}

struct WeatherResultMain: Codable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Int
    let humidity: Double
}

struct WeatherResultWind: Codable {
    let speed: Double
}

struct WeatherResultClouds: Codable {
    let all: Double
}

struct WeatherResultName: Codable {
    let name: String
}

    
    
//    var coord: [String: Double]
//    var weather: [String: String]
//    var base: String
//    var main: [String: Double]
//    var visibility: Int
//    var wind: [String: Double]
//    var clouds: [String: Double]
//    var dt: Int
//    var sys: [String: String]
//    var timezone: Double
//    var id : Int
//    var name: String
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

