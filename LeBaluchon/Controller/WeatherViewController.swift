//
//  WeatherViewController.swift
//  LeBaluchon
//
//  Created by Romain Buewaert on 26/07/2021.
//

import UIKit

class WeatherViewController: UIViewController {
    var weatherLeftCity: Weather!
    var weatherRightCity: Weather!

    var firstRequestFinished = false
    var secondRequestFinished = false

    @IBOutlet var cityLabel: [UILabel]!
    @IBOutlet var weatherLabel: [UILabel]!
    @IBOutlet var imageView: [UIImageView]!
    @IBOutlet var tempLabel: [UILabel]!
    @IBOutlet var feltTempLabel: [UILabel]!
    @IBOutlet var tempMinLabel: [UILabel]!
    @IBOutlet var tempMaxLabel: [UILabel]!
    @IBOutlet var windLabel: [UILabel]!
    @IBOutlet var cloudinessLabel: [UILabel]!
    @IBOutlet var humidityLabel: [UILabel]!
    @IBOutlet var pressureLabel: [UILabel]!

    /*
     TESTER : Diminuer le nbre de label ci-dessus avec les tag !!!
     */

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        orderOutletCollectionWithTags()

        WeatherService.shared.getWeatherGroup { success, weatherLeftCity, weatherRightCity in
            if success, let currentWeatherLeftCity = weatherLeftCity, let currentWeatherRightCity = weatherRightCity {
                self.weatherLeftCity = currentWeatherLeftCity
                self.weatherRightCity = currentWeatherRightCity
                self.updateWeatherView(weather: self.weatherLeftCity, index: 0)
                self.updateWeatherView(weather: self.weatherRightCity, index: 1)
                print("bravo 1")
            } else {
                self.alertErrorMessage(message: ErrorType.downloadFailed.rawValue)
                print("erreur de recup 1  ??????")
            }
        }
    }

    private func orderOutletCollectionWithTags() {
        cityLabel = cityLabel.sorted { $0.tag < $1.tag }
        weatherLabel = weatherLabel.sorted { $0.tag < $1.tag }
        imageView = imageView.sorted { $0.tag < $1.tag }
        tempLabel = tempLabel.sorted { $0.tag < $1.tag }
        feltTempLabel = feltTempLabel.sorted { $0.tag < $1.tag }
        tempMinLabel = tempMinLabel.sorted { $0.tag < $1.tag }
        tempMaxLabel = tempMaxLabel.sorted { $0.tag < $1.tag }
        windLabel = windLabel.sorted { $0.tag < $1.tag }
        cloudinessLabel = cloudinessLabel.sorted { $0.tag < $1.tag }
        humidityLabel = humidityLabel.sorted { $0.tag < $1.tag }
        pressureLabel = pressureLabel.sorted { $0.tag < $1.tag }
    }

    private func updateWeatherView(weather: Weather, index: Int) {
        cityLabel[index].text = weather.city
        weatherLabel[index].text = weather.description
        updateImageView(imageView: imageView[index], weather: weather)
        tempLabel[index].text = "Temperature : \(weather.temperature)°C"
        feltTempLabel[index].text = "Felt temperature : \(weather.feltTemperature)°C"
        tempMinLabel[index].text = "Temperature min. : \(weather.temperatureMin)°C"
        tempMaxLabel[index].text = "Temperature max. : \(weather.temperatureMax)°C"
        windLabel[index].text = "Wind : \(weather.windSpeed)km/h"
        cloudinessLabel[index].text = "Cloudiness: \(weather.cloudiness)%"
        humidityLabel[index].text = "Humidity : \(weather.humidity)%"
        pressureLabel[index].text = "Pressure : \(weather.pressure)hPa"
    }

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
    }

    private func alertErrorMessage(message: String) {
        let alertVC = UIAlertController(title: "Error!", message: message,
                                        preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
}
