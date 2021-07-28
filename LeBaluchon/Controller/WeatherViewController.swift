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

    @IBOutlet weak var leftCityLabel: UILabel!
    @IBOutlet weak var leftWeatherLabel: UILabel!
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var leftTempLabel: UILabel!
    @IBOutlet weak var leftFeltTempLabel: UILabel!
    @IBOutlet weak var leftTempMinLabel: UILabel!
    @IBOutlet weak var leftTempMaxLabel: UILabel!
    @IBOutlet weak var leftPressureLabel: UILabel!
    @IBOutlet weak var leftHumidityLabel: UILabel!
    @IBOutlet weak var leftWindLabel: UILabel!
    @IBOutlet weak var leftCloudinessLabel: UILabel!

    @IBOutlet weak var rightCityLabel: UILabel!
    @IBOutlet weak var rightWeatherLabel: UILabel!
    @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var rightTempLabel: UILabel!
    @IBOutlet weak var rightFeltTempLabel: UILabel!
    @IBOutlet weak var rightTempMinLabel: UILabel!
    @IBOutlet weak var rightTempMaxLabel: UILabel!
    @IBOutlet weak var rightPressureLabel: UILabel!
    @IBOutlet weak var rightHumidityLabel: UILabel!
    @IBOutlet weak var rightWindLabel: UILabel!
    @IBOutlet weak var rightCloudinessLabel: UILabel!
    
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
        let outletList = [leftCityLabel, leftWeatherLabel, leftImageView, leftTempLabel]
        for outlet in outletList {
            if outlet!.tag == tag {
                leftCityLabel.text = "toto"
            }
        }
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
