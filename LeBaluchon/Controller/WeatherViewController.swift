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

    @IBOutlet var cityLabel: [UILabel]!
    @IBOutlet var weatherLabel: [UILabel]!
    @IBOutlet var imageView: [UIImageView]!
    @IBOutlet var tempLabel: [UILabel]!
    @IBOutlet var feltTempLabel: [UILabel]!
    @IBOutlet var tempMinLabel: [UILabel]!
    @IBOutlet var tempMaxLabel: [UILabel]!
    @IBOutlet var pressureLabel: [UILabel]!
    @IBOutlet var humidityLabel: [UILabel]!
    @IBOutlet var windLabel: [UILabel]!
    @IBOutlet var cloudinessLabel: [UILabel]!
    
    
    /*
     TESTER : Diminuer le nbre de label ci-dessus avec les tag !!!
     */
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        WeatherService.shared.getWeather(city: "Toulouse") { (success, weather) in
//                            self.toggleActivityIndicator(shown: false)
        
                            if success, let currentWeather = weather {
                                self.weatherLeftCity = currentWeather
//                                self.update(currency: currentCurrency)
//                                print(self.currency.exchangeRate)
                                print("bravo")
                            } else {
//                                self.errorMessage(message: ErrorType.downloadFailed.rawValue)
                                print("erreur")
                            }
                        }

        WeatherService.shared.getWeather(city: "New York") { (success, weather) in
//                            self.toggleActivityIndicator(shown: false)
        
                            if success, let currentWeather = weather {
                                self.weatherRightCity = currentWeather
//                                self.update(currency: currentCurrency)
//                                print(self.currency.exchangeRate)
                                print("bravo")
                            } else {
//                                self.errorMessage(message: ErrorType.downloadFailed.rawValue)
                                print("erreur")
                            }
                        }
        
        
        
        
        
    }

    private func updateWeatherView(weather: Weather, tag: Int) {
        cityLabel[0].text = ""
        
        
        
//        let outletList = [cityLabel, leftWeatherLabel, leftImageView, leftTempLabel, leftFeltTempLabel, leftTempMinLabel, leftTempMaxLabel, leftPressureLabel, leftHumidityLabel, leftWindLabel, leftCloudinessLabel, rightCityLabelTest, rightWeatherLabel, rightImageView, rightTempLabel, rightFeltTempLabel, rightTempMinLabel, rightTempMaxLabel, rightPressureLabel, rightHumidityLabel, rightWindLabel, rightCloudinessLabel]
//        for outlet in outletList {
//            if outlet!.tag == tag {
//                cityLabel.text = "City: \(weather.city)"
//            }
//        }
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
