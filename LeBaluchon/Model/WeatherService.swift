//
//  WeatherService.swift
//  LeBaluchon
//
//  Created by Romain Buewaert on 27/07/2021.
//

import Foundation

final class WeatherService {
    // MARK: - Pattern Singleton
    static var shared = WeatherService()
    private init() {}

    // MARK: - Dependency injection
    private var task: URLSessionDataTask?
    private var weatherSession = URLSession(configuration: .default)

    init(weatherSession: URLSession) {
        self.weatherSession = weatherSession
    }

    var requestSuccess = false
    var cityIsFound = true

    private static let baseWeatherUrlCity = "http://api.openweathermap.org/data/2.5/weather?q="
    private static let baseWeatherUrlGroup = "http://api.openweathermap.org/data/2.5/group?id="
    private static let units = "&units=metric"

    private let urlParameters = "&appid=" + keyOpenWeather + units
    // Toulouse id = 2972315
    // New York id = 5128581
    // Beaumont de Lomagne id = 3034170

    private func calculCityHour(timezone: Int) -> String {
        let hour = NSDate.init(timeIntervalSinceNow: TimeInterval(timezone))

        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.timeStyle = .short

        return formatter.string(from: hour as Date)
    }

    func getWeatherGroup(callback: @escaping (Bool, Weather?, Weather?) -> Void) {
        guard let url = URL(string: WeatherService.baseWeatherUrlGroup + SelectedParameters.selectedId + urlParameters) else {
            callback(false, nil, nil)
            return
        }

        task?.cancel()

        task = weatherSession.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    return callback(false, nil, nil)
                }
                guard let response = response as? HTTPURLResponse, (response.statusCode == 200) else {
                    return callback(false, nil, nil)
                }

                // Extract property indicated in Struct WeatherResult
                guard let JSONresult = try? JSONDecoder().decode(WeatherResult.self, from: data) else {
                    return callback(false, nil, nil)
                }

                let resultWeatherBeaumont = JSONresult.list[0].weather
                let resultMainBeaumont = JSONresult.list[0].main

                let resultWeatherNewYork = JSONresult.list[1].weather
                let resultMainNewYork = JSONresult.list[1].main

                let weather1 = Weather(city: JSONresult.list[0].name,
                                        hour: self.calculCityHour(timezone: JSONresult.list[0].sys.timezone),
                                        description: resultWeatherBeaumont[0].description,
                                        icon: resultWeatherBeaumont[0].icon,
                                        temperature: round(resultMainBeaumont.temp * 10) / 10.0,
                                        feltTemperature: round(resultMainBeaumont.feelsLike * 10) / 10.0,
                                        pressure: resultMainBeaumont.pressure,
                                        humidity: resultMainBeaumont.humidity,
                                        windSpeed: (3.6 * JSONresult.list[0].wind.speed).rounded(),
                                        cloudiness: JSONresult.list[0].clouds.all,
                                        id: JSONresult.list[0].id)

                let weather2 = Weather(city: JSONresult.list[1].name,
                                       hour: self.calculCityHour(timezone: JSONresult.list[1].sys.timezone),
                                       description: resultWeatherNewYork[0].description,
                                       icon: resultWeatherNewYork[0].icon,
                                       temperature: round(resultMainNewYork.temp * 10) / 10.0,
                                       feltTemperature: round(resultMainNewYork.feelsLike * 10) / 10.0,
                                       pressure: resultMainNewYork.pressure,
                                       humidity: resultMainNewYork.humidity,
                                       windSpeed: (3.6 * JSONresult.list[1].wind.speed).rounded(),
                                       cloudiness: JSONresult.list[1].clouds.all,
                                       id: JSONresult.list[1].id)

                callback(true, weather1, weather2)
            }
        }
        task?.resume()
    }

    func getWeatherCity(city: String, callback: @escaping (Bool, Weather?) -> Void) {
        cityIsFound = true

        guard let url = URL(string: WeatherService.baseWeatherUrlCity + city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! + urlParameters) else {
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
                    self.cityIsFound = false
                    print("city not found Throws!!!!")
                }

                /* ATTENTION StatusCode 404:
                 {
                     "cod": "404",
                     "message": "city not found"
                 }
                 */

                // Extract property indicated in Struct WeatherResultList
                guard let JSONresult = try? JSONDecoder().decode(WeatherResultListCity.self, from: data) else {
                    return callback(false, nil)
                }

                let resultTimezone = JSONresult.timezone
                let resultWeather = JSONresult.weather
                let resultMain = JSONresult.main
                let resultWind = JSONresult.wind
                let resultClouds = JSONresult.clouds

                let weather = Weather(city: city,
                                      hour: self.calculCityHour(timezone: resultTimezone),
                                      description: resultWeather[0].description,
                                      icon: resultWeather[0].icon,
                                      temperature: round(resultMain.temp * 10) / 10.0,
                                      feltTemperature: round(resultMain.feelsLike * 10) / 10.0,
                                      pressure: resultMain.pressure,
                                      humidity: resultMain.humidity,
                                      windSpeed: (3.6 * resultWind.speed).rounded(),
                                      cloudiness: resultClouds.all,
                                      id: JSONresult.id)
                callback(true, weather)
                print("new id dans MODEL \(weather.id)")
            }
        }
        task?.resume()
    }
}
