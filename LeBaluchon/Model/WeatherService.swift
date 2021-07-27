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

}
