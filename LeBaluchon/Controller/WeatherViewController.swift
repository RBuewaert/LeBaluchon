//
//  WeatherViewController.swift
//  LeBaluchon
//
//  Created by Romain Buewaert on 26/07/2021.
//

import UIKit

final class WeatherViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet var cityLabel: [UILabel]!
    @IBOutlet var hourLabel: [UILabel]!
    @IBOutlet var weatherLabel: [UILabel]!
    @IBOutlet var imageView: [UIImageView]!
    @IBOutlet var tempLabel: [UILabel]!
    @IBOutlet var feltTempLabel: [UILabel]!
    @IBOutlet var windLabel: [UILabel]!
    @IBOutlet var cloudinessLabel: [UILabel]!
    @IBOutlet var humidityLabel: [UILabel]!
    @IBOutlet var pressureLabel: [UILabel]!

    // MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit,
                                            target: self, action: #selector(launchParametersViewController))
        self.tabBarController?.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh,
                                            target: self, action: #selector(updateCurrentViewController))

        orderOutletCollectionWithTags()

        WeatherService.shared.getWeatherGroup { success, weatherLeftCity, weatherRightCity in
            if success, let currentWeatherLeftCity = weatherLeftCity, let currentWeatherRightCity = weatherRightCity {
                SelectedParameters.selectedWeatherLeftCity = currentWeatherLeftCity
                SelectedParameters.selectedWeatherRightCity = currentWeatherRightCity
                self.updateWeatherView(weather: currentWeatherLeftCity, index: 0)
                self.updateWeatherView(weather: currentWeatherRightCity, index: 1)
                WeatherService.shared.requestSuccess = true
            } else {
                self.alertErrorMessage(message: ErrorType.downloadFailed.rawValue)
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        if WeatherService.shared.requestSuccess == true {
            WeatherService.shared.getWeatherGroup { success, weatherLeftCity, weatherRightCity in
                if success, let currentWeatherLeftCity = weatherLeftCity,
                            let currentWeatherRightCity = weatherRightCity {
                    SelectedParameters.selectedWeatherLeftCity = currentWeatherLeftCity
                    SelectedParameters.selectedWeatherRightCity = currentWeatherRightCity
                    self.updateWeatherView(weather: currentWeatherLeftCity, index: 0)
                    self.updateWeatherView(weather: currentWeatherRightCity, index: 1)
                } else {
                    self.alertErrorMessage(message: ErrorType.downloadFailed.rawValue)
                }
            }
        }
    }

    // MARK: - Private methods
    private func orderOutletCollectionWithTags() {
        cityLabel = cityLabel.sorted { $0.tag < $1.tag }
        hourLabel = hourLabel.sorted { $0.tag < $1.tag }
        weatherLabel = weatherLabel.sorted { $0.tag < $1.tag }
        imageView = imageView.sorted { $0.tag < $1.tag }
        tempLabel = tempLabel.sorted { $0.tag < $1.tag }
        feltTempLabel = feltTempLabel.sorted { $0.tag < $1.tag }
        windLabel = windLabel.sorted { $0.tag < $1.tag }
        cloudinessLabel = cloudinessLabel.sorted { $0.tag < $1.tag }
        humidityLabel = humidityLabel.sorted { $0.tag < $1.tag }
        pressureLabel = pressureLabel.sorted { $0.tag < $1.tag }
    }

    private func updateWeatherView(weather: Weather, index: Int) {
        cityLabel[index].text = weather.city
        hourLabel[index].text = weather.hour
        weatherLabel[index].text = weather.description
        updateImageView(imageView: imageView[index], weather: weather)
        tempLabel[index].text = "Temperature : \(weather.temperature)°C"
        feltTempLabel[index].text = "Felt temperature : \(weather.feltTemperature)°C"
        windLabel[index].text = "Wind : \(weather.windSpeed)km/h"
        cloudinessLabel[index].text = "Cloudiness: \(weather.cloudiness)%"
        humidityLabel[index].text = "Humidity : \(weather.humidity)%"
        pressureLabel[index].text = "Pressure : \(weather.pressure)hPa"
    }

    // swiftlint:disable cyclomatic_complexity
    private func updateImageView(imageView: UIImageView, weather: Weather) {
        switch weather.icon {
        case "01d":
            imageView.image = UIImage(named: "sunDay")
        case "01n":
            imageView.image = UIImage(named: "moonNight")
        case "02d":
            imageView.image = UIImage(named: "fewCloudsDay")
        case "02n":
            imageView.image = UIImage(named: "fewCloudsNight")
        case "03d", "03n":
            imageView.image = UIImage(named: "brokenClouds")
        case "04d", "04n":
            imageView.image = UIImage(named: "overcastClouds")
        case "09d", "09n":
            imageView.image = UIImage(named: "heavyRain")
        case "10d":
            imageView.image = UIImage(named: "lightRainDay")
        case "10n":
            imageView.image = UIImage(named: "lightRainNight")
        case "11d", "11n":
            imageView.image = UIImage(named: "thunderstorm")
        case "13d", "13n":
            imageView.image = UIImage(named: "snow")
        case "50d", "50n":
            imageView.image = UIImage(named: "mist")
        default:
            return
        }
        // swiftlint:enable cyclomatic_complexity
    }

    // MARK: - UIAlertController
    private func alertErrorMessage(message: String) {
        let alertVC = UIAlertController(title: "Error!", message: message,
                                        preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
}

// MARK: - Methods for NavigationItem Buttons
extension WeatherViewController {
    @objc func launchParametersViewController() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let parametersViewController = storyBoard.instantiateViewController(
                withIdentifier: "Parameters") as? ParametersViewController else { return}
        self.present(parametersViewController, animated: true, completion: nil)
    }

    @objc func updateCurrentViewController() {
        self.updateWeatherView(weather: SelectedParameters.selectedWeatherLeftCity, index: 0)
        self.updateWeatherView(weather: SelectedParameters.selectedWeatherRightCity, index: 1)
    }
}
