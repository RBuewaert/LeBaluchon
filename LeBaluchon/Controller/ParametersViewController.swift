//
//  ParametersViewController.swift
//  LeBaluchon
//
//  Created by Romain Buewaert on 24/08/2021.
//

import UIKit

class ParametersViewController: UIViewController {
    var currency: Currency!
    var translation: Translation!
    var weatherLeftCity: Weather!
    var weatherRightCity: Weather!

    var currencyNames: [String] = []
    var languageNames: [String] = []
    var suggestedCities: [String] = []

    @IBOutlet weak var firstSuggestionPickerView: UIPickerView!
    @IBOutlet weak var secondSuggestionPickerView: UIPickerView!
    @IBOutlet weak var firstDevicePickerView: UIPickerView!
    @IBOutlet weak var secondDevicePickerView: UIPickerView!
    @IBOutlet weak var firstLanguagePickerView: UIPickerView!
    @IBOutlet weak var secondLanguagePickerView: UIPickerView!
    @IBOutlet weak var firstCityTextField: UITextField!
    @IBOutlet weak var secondCityTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func tappedResetButton(_ sender: Any) {
    }

    @IBAction func tappedValidateButton(_ sender: Any) {
    }
    
    
    

}


// MARK: - PickerView
extension ParametersViewController: UIPickerViewDataSource, UIPickerViewDelegate {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
//        switch pickerView.tag {
//        case 0, 1:
//            return 3
//        case 2...5:
//            return 1
//        default:
//            return 1
//        }
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 0, 1:
            return listOfCities.count
        case 2, 3:
            return currencyList.count
        case 4, 5:
            return languageList.count
        default:
            return 1
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 0, 1:
            let cityName = listOfCities[row].name
            let cityDevice = listOfCities[row].device
            let cityLanguage = listOfCities[row].language
            return "\(cityName), \(cityDevice), \(cityLanguage)"
        case 2, 3:
            selectCurrencyNamesOnly()
            return currencyNames[row]
        case 4, 5:
            selectLanguageNamesOnly()
            return languageNames[row]
        default:
            return "Data not found"
        }
    }

    private func selectCurrencyNamesOnly() {
        for (_, currencyName) in currencyList {
            currencyNames.append(currencyName)
        }
    }

    private func selectLanguageNamesOnly() {
        for (_, languageName) in languageList {
            languageNames.append(languageName)
        }
    }
}

// MARK: - Extension Dictionary (use to find key associated to language)
extension Dictionary where Value: Equatable {
    func someKey(forValue val: Value) -> Key? {
        return first(where: { $1 == val })?.key
    }
}

/*
extension Dictionary where Value: Equatable {
    func someKey(forValue val: Value) -> Key? {
        return first(where: { $1 == val })?.key
    }
}
Example usage:

let dict: [Int: String] = [1: "one", 2: "two", 4: "four"]

if let key = dict.someKey(forValue: "two") {
    print(key)
} // 2
*/
