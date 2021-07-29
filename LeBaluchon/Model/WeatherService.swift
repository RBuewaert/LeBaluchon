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

    private static let baseWeatherUrl = "http://api.openweathermap.org/data/2.5/weather?q="
    private let units = "&units=metric"

    func getWeather(city: String, callback: @escaping (Bool, Weather?) -> Void ) {
        guard let url = URL(string: WeatherService.baseWeatherUrl + city + "&appid=" + keyOpenWeather + units) else {
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
                guard let response = response as? HTTPURLResponse, (response.statusCode == 200) || (response.statusCode == 404) else {
                    callback(false, nil)
                    return
                }

                if response.statusCode == 404 {
                    print("city not found Throws!!!!")
                }

                /* ATTENTION PRENDRE EN COMPTE:
                 {
                     "cod": "404",
                     "message": "city not found"
                 }
                 */

                // Extract property indicated in Struc WeatherResult
                guard let JSONresult = try? JSONDecoder().decode(WeatherResult.self, from: data) else {
                    return callback(false, nil)
                }

                let result = JSONresult
                let resultWeather = JSONresult.weather
                let resultMain = JSONresult.main
                let resultWind = JSONresult.wind
                let resultClouds = JSONresult.clouds
//                print(result.weather.count)
//                print(result.weather)
//                print("test")
//                print(result.weather.description)
//                print(resultWeather.description)
//                print("test")
//                print(resultWeather[0].icon)
//                print(result)

                /* vitesste du vent par défaut metre par s :
                Une vitesse de 1 m/s correspond à 3,6 km/h soit 1,9 nœuds. Une vitesse de 25 m/s correspond à 90 km/h soit 49 nœuds. Une vitesse de 28 m/s correspond à 100 km/h soit 54 nœuds.
                */

                let weather = Weather(city: result.name,
                                      description: resultWeather[0].description,
                                      icon: resultWeather[0].icon,
                                      temperature: round(resultMain.temp * 10) / 10.0,
                                      feltTemperature: round(resultMain.feels_like * 10) / 10.0,
                                      temperatureMin: round(resultMain.temp_min * 10) / 10.0,
                                      temperatureMax: round(resultMain.temp_max * 10) / 10.0,
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
