//
//  WeatherService.swift
//  LeBaluchon
//
//  Created by Romain Buewaert on 27/07/2021.
//

import Foundation

class WeatherService {
    // Pattern Singleton
    static var shared = WeatherService()
    private init() {}

    // Dependency injection
    private var task: URLSessionDataTask?
    private var weatherSession = URLSession(configuration: .default)

    init(weatherSession: URLSession) {
        self.weatherSession = weatherSession
    }

    private static let baseWeatherUrlCity = "http://api.openweathermap.org/data/2.5/weather?q="
    private static let baseWeatherUrlGroup = "http://api.openweathermap.org/data/2.5/group?id="
    private static let units = "&units=metric"

    private let urlParameters = "&appid=" + keyOpenWeather + units
    private let idBeaumontNewYork = "3034170,5128581"
    // Toulouse id = 2972315
    // New York id = 5128581
    // Beaumont de Lomagne id = 3034170

    func getWeatherGroup(callback: @escaping (Bool, Weather?, Weather?) -> Void) {
        guard let url = URL(string: WeatherService.baseWeatherUrlGroup + idBeaumontNewYork + urlParameters) else {
            callback(false, nil, nil)
            return
        }

        task?.cancel()

        task = weatherSession.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(false, nil, nil)
                    return
                }
                guard let response = response as? HTTPURLResponse, (response.statusCode == 200) else {
                    callback(false, nil, nil)
                    return
                }

                // Extract property indicated in Struc WeatherResult
                guard let JSONresult = try? JSONDecoder().decode(WeatherResult.self, from: data) else {
                    return callback(false, nil, nil)
                }

                let resultBeaumont = JSONresult.list[0]
                let resultWeatherBeaumont = JSONresult.list[0].weather
                let resultMainBeaumont = JSONresult.list[0].main
                let resultWindBeaumont = JSONresult.list[0].wind
                let resultCloudsBeaumont = JSONresult.list[0].clouds

                let resultNewYork = JSONresult.list[1]
                let resultWeatherNewYork = JSONresult.list[1].weather
                let resultMainNewYork = JSONresult.list[1].main
                let resultWindNewYork = JSONresult.list[1].wind
                let resultCloudsNewYork = JSONresult.list[1].clouds

                /* vitesste du vent par défaut metre par s :
                Une vitesse de 1 m/s correspond à 3,6 km/h soit 1,9 nœuds. Une vitesse de 25 m/s correspond à 90 km/h soit 49 nœuds. Une vitesse de 28 m/s correspond à 100 km/h soit 54 nœuds.
                */

                let weather1 = Weather(city: resultBeaumont.name,
                                      description: resultWeatherBeaumont[0].description,
                                      icon: resultWeatherBeaumont[0].icon,
                                      temperature: round(resultMainBeaumont.temp * 10) / 10.0,
                                      feltTemperature: round(resultMainBeaumont.feelsLike * 10) / 10.0,
                                      temperatureMin: round(resultMainBeaumont.tempMin * 10) / 10.0,
                                      temperatureMax: round(resultMainBeaumont.tempMax * 10) / 10.0,
                                      pressure: resultMainBeaumont.pressure,
                                      humidity: resultMainBeaumont.humidity,
                                      windSpeed: (3.6 * resultWindBeaumont.speed).rounded(),
                                      cloudiness: resultCloudsBeaumont.all)

                let weather2 = Weather(city: resultNewYork.name,
                                      description: resultWeatherNewYork[0].description,
                                      icon: resultWeatherNewYork[0].icon,
                                      temperature: round(resultMainNewYork.temp * 10) / 10.0,
                                      feltTemperature: round(resultMainNewYork.feelsLike * 10) / 10.0,
                                      temperatureMin: round(resultMainNewYork.tempMin * 10) / 10.0,
                                      temperatureMax: round(resultMainNewYork.tempMax * 10) / 10.0,
                                      pressure: resultMainNewYork.pressure,
                                      humidity: resultMainNewYork.humidity,
                                      windSpeed: (3.6 * resultWindNewYork.speed).rounded(),
                                      cloudiness: resultCloudsNewYork.all)

                callback(true, weather1, weather2)
            }
        }
        task?.resume()
    }

    func getWeatherCity(city: String, callback: @escaping (Bool, Weather?) -> Void) {
        guard let url = URL(string: WeatherService.baseWeatherUrlCity + city + urlParameters) else {
            callback(false, nil)
            return
        }

        task?.cancel()

        task = weatherSession.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(false, nil)
                    return
                }
                guard let response = response as? HTTPURLResponse,
                      (response.statusCode == 200) || (response.statusCode == 404) else {
                    callback(false, nil)
                    return
                }

                if response.statusCode == 404 {
                    print("city not found Throws!!!!")
                }

                /* ATTENTION StatusCode 404:
                 {
                     "cod": "404",
                     "message": "city not found"
                 }
                 */

                // Extract property indicated in Struc WeatherResult
                guard let JSONresult = try? JSONDecoder().decode(WeatherResultList.self, from: data) else {
                    return callback(false, nil)
                }

                let result = JSONresult
                let resultWeather = JSONresult.weather
                let resultMain = JSONresult.main
                let resultWind = JSONresult.wind
                let resultClouds = JSONresult.clouds

                /* vitesste du vent par défaut metre par s :
                Une vitesse de 1 m/s correspond à 3,6 km/h soit 1,9 nœuds. Une vitesse de 25 m/s correspond à 90 km/h soit 49 nœuds. Une vitesse de 28 m/s correspond à 100 km/h soit 54 nœuds.
                */

                let weather = Weather(city: result.name,
                                      description: resultWeather[0].description,
                                      icon: resultWeather[0].icon,
                                      temperature: round(resultMain.temp * 10) / 10.0,
                                      feltTemperature: round(resultMain.feelsLike * 10) / 10.0,
                                      temperatureMin: round(resultMain.tempMin * 10) / 10.0,
                                      temperatureMax: round(resultMain.tempMax * 10) / 10.0,
                                      pressure: resultMain.pressure,
                                      humidity: resultMain.humidity,
                                      windSpeed: (3.6 * resultWind.speed).rounded(),
                                      cloudiness: resultClouds.all)
                callback(true, weather)

            }
        }
        task?.resume()
    }
}
