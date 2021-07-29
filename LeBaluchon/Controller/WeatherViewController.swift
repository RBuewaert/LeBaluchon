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

    var firstRequestFinished = true
    var secondRequestFinished = true

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

        WeatherService.shared.getWeather(city: "Toulouse") { (success, weather) in
//            self.toggleActivityIndicator(shown: false)
        
            if success, let currentWeather = weather {
                self.weatherLeftCity = currentWeather
                self.updateWeatherView(weather: self.weatherLeftCity, index: 0)
                print("bravo 1")
            } else {
//                self.alertErrorMessage(message: ErrorType.downloadFailed.rawValue)
                print("erreur de recup 1  ??????")
            }
        }
        
        WeatherService.shared.getWeather(city: "New York") { (success, weather) in
//            self.toggleActivityIndicator(shown: false)
            
            if success, let currentWeather = weather {
                self.weatherRightCity = currentWeather
                self.updateWeatherView(weather: self.weatherRightCity, index: 1)
                print("bravo 2")
            } else {
//                self.errorMessage(message: ErrorType.downloadFailed.rawValue)
                print("erreur de recup 2  ??????")
            }
        }

//        updateWeatherView(weather: weatherLeftCity, index: 0)
        

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
        cityLabel[index].text = "City: \(weather.city)"
        weatherLabel[index].text = "Weather: \(weather.description)"
//        imageView
        tempLabel[index].text = "Temperature : \(weather.temperature)°C"
        feltTempLabel[index].text = "Felt temperature : \(weather.feltTemperature)°C"
        tempMinLabel[index].text = "Temperature min. : \(weather.temperatureMin)°C"
        tempMaxLabel[index].text = "Temperature max. : \(weather.temperatureMax)°C"
        windLabel[index].text = "Wind : \(weather.windSpeed)km/h"
        cloudinessLabel[index].text = "Cloudiness: \(weather.cloudiness)%"
        humidityLabel[index].text = "Humidity : \(weather.humidity)%"
        pressureLabel[index].text = "Pressure : \(weather.pressure)hPa"
    
        
        
    }

    private func alertErrorMessage(message: String) {
        let alertVC = UIAlertController(title: "Error!", message: message,
                                        preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
   
    
    
    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        print("B : init")
//    }
//
//    override func loadView() {
//        super.loadView()
//        print("B : loadView")
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        print("B : viewDidLoad")
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        print("B : viewWillAppear")
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        print("B : viewDidAppear")
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        print("B : viewWillDisappear")
//    }
//
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        print("B : viewDidDisappear")
//    }
}
