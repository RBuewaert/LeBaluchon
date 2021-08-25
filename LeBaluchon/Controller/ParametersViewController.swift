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

    var deviceNames: [String] = []
    var languageNames: [String] = []
    var suggestedCities: [String] = []

    @IBOutlet weak var suggestionTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var languageTextField: UITextField!
    @IBOutlet weak var deviceTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var segmentControl: UISegmentedControl!

    var suggestionPickerView = UIPickerView()
    var devicePickerView = UIPickerView()
    var languagePickerView = UIPickerView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        suggestionTextField.inputView = suggestionPickerView
        deviceTextField.inputView = devicePickerView
        languageTextField.inputView = languagePickerView

        suggestionPickerView.delegate = self
        suggestionPickerView.dataSource = self
        devicePickerView.delegate = self
        devicePickerView.dataSource = self
        languagePickerView.delegate = self
        languagePickerView.dataSource = self

        suggestionPickerView.tag = 0
        devicePickerView.tag = 1
        languagePickerView.tag = 2
    }

    @IBAction func tappedResetButton(_ sender: Any) {
    }

    @IBAction func tappedValidateButton(_ sender: Any) {
    }

}

// MARK: - Keyboard
extension ParametersViewController: UITextViewDelegate {
    func textViewShouldReturn(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }

    @IBAction func dismissKeyboard(_ sender: Any) {
        cityTextField.endEditing(true)
    }
}

// MARK: - PickerView
extension ParametersViewController: UIPickerViewDataSource, UIPickerViewDelegate {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 0:
            return listOfCities.count
        case 1:
            return deviceList.count
        case 2:
            return languageList.count
        default:
            return 1
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 0:
            let cityName = listOfCities[row].name
            let cityDevice = listOfCities[row].device
            let cityLanguage = listOfCities[row].language
            return "\(cityName), \(cityDevice), \(cityLanguage)"
        case 1:
            selectDeviceNamesOnly()
            return deviceNames[row]
        case 2:
            selectLanguageNamesOnly()
            return languageNames[row]
        default:
            return "Data not found"
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 0:
            let cityName = listOfCities[row].name
            let cityDevice = listOfCities[row].device
            let cityLanguage = listOfCities[row].language
            suggestionTextField.text = "\(cityName), \(cityDevice), \(cityLanguage)"
            suggestionTextField.resignFirstResponder()
        case 1:
            deviceTextField.text = deviceNames[row]
            deviceTextField.resignFirstResponder()
        case 2:
            languageTextField.text = languageNames[row]
            languageTextField.resignFirstResponder()
        default:
            return
        }
    }

    private func selectDeviceNamesOnly() {
        for (_, currencyName) in deviceList {
            deviceNames.append(currencyName)
        }
//        deviceNames.sort()
    }

    private func selectLanguageNamesOnly() {
        for (_, languageName) in languageList {
            languageNames.append(languageName)
        }
//        languageNames.sort()
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
