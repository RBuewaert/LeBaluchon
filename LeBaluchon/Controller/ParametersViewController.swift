//
//  ParametersViewController.swift
//  LeBaluchon
//
//  Created by Romain Buewaert on 24/08/2021.
//

import UIKit

final class ParametersViewController: UIViewController {
    var currentWeather: Weather!
    var cityResearch = false
    var idLinkToPickerView = 0
    var idLinkToCity = 0

    var deviceNames: [String] = []
    var languageNames: [String] = []
    var suggestedCities: [String] = []

    @IBOutlet weak var suggestionTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var languageTextField: UITextField!
    @IBOutlet weak var deviceTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var validateButton: UIButton!

    var suggestionPickerView = UIPickerView()
    var devicePickerView = UIPickerView()
    var languagePickerView = UIPickerView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        validateButton.layer.cornerRadius = 30

        suggestionTextField.inputView = suggestionPickerView
        deviceTextField.inputView = devicePickerView
        languageTextField.inputView = languagePickerView

        initializePickerView(pickerView: suggestionPickerView)
        initializePickerView(pickerView: devicePickerView)
        initializePickerView(pickerView: languagePickerView)

        suggestionPickerView.tag = 0
        devicePickerView.tag = 1
        languagePickerView.tag = 2
    }

    override func viewWillDisappear(_ animated: Bool) {

        
    }

    private func determineActiveViewController(vc: UIViewController) -> Bool {
        
        
        guard vc.viewIfLoaded?.window != nil else {return false }
        return true
    }

    /*
     check si view controller visible
    if viewController.viewIfLoaded?.window != nil {
        // viewController is visible
    }
 */

 
 
    private func initializePickerView(pickerView: UIPickerView) {
        pickerView.delegate = self
        pickerView.dataSource = self
    }

    @IBAction func tappedValidateButton(_ sender: Any) {
        toggleActivityIndicator(shown: true)

        print(SelectedParameters.secondSelectedId)

        if suggestionTextField.text == "" && languageTextField.text == "" && deviceTextField.text == "" && cityTextField.text == "" {
            alertErrorMessage(message: ErrorType.noValue.rawValue)
        }

        if cityTextField.text != nil && cityTextField.text != "" {
            checkCityName(cityTapped: cityTextField)
        }
        else {
            extractValues()
            toggleActivityIndicator(shown: false)
        }

//        let suggestion = suggestionTextField.text
//        let language = languageTextField.text
//        let device = deviceTextField.text

//        if suggestion == nil && language == nil && device == nil && cityResearch == false {
//            alertErrorMessage(message: ErrorType.noValue.rawValue)
//        }

//        extractValues()

//        toggleActivityIndicator(shown: false)
    }

    private func checkCityName(cityTapped: UITextField) {
//        let citySearched = cityTapped.text?.replacingOccurrences(of: " ", with: "-")

//        if cityTapped.text != nil && cityTapped.text != "" { break }

        print(SelectedParameters.secondSelectedId)
        
        WeatherService.shared.getWeatherCity(city: cityTapped.text!) { success, weather in
            if success, let currentWeather = weather {
                self.currentWeather = currentWeather
                self.idLinkToCity = currentWeather.id
                self.cityResearch = true
                self.extractValues()
                self.toggleActivityIndicator(shown: false)
                print(SelectedParameters.secondSelectedId)
            } else if WeatherService.shared.cityIsFound == false {
                self.cityResearch = false
                self.alertErrorMessage(message: ErrorType.cityNotFound.rawValue)
            } else {
                self.cityResearch = false
                self.alertErrorMessage(message: ErrorType.downloadFailed.rawValue)
            }
        }
    }

    private func extractValues() {
        if segmentControl.selectedSegmentIndex == 0 {
            if suggestionTextField.text != "" {
                SelectedParameters.firstSelectedId = idLinkToPickerView
                return
            }
            if languageTextField.text != "" {
                if let key = Lists.languageList.someKey(forValue: languageTextField.text!) {
                    SelectedParameters.selectedLanguageToTranslate = key
                }
            }
            if deviceTextField.text != "" {
                if let key = Lists.deviceList.someKey(forValue: deviceTextField.text!) {
                    SelectedParameters.selectedCurrency.currencyToConvert = key
                }
            }
            if cityResearch == true {
                SelectedParameters.selectedWeatherLeftCity = currentWeather
                SelectedParameters.firstSelectedId = idLinkToCity
            }
            succesMessage(element: "the first element")
        } else { // segmentControl.selectedSegmentIndex == 1
            if suggestionTextField.text != "" {
                SelectedParameters.secondSelectedId = idLinkToPickerView
                return
            }
            if languageTextField.text != "" {
                if let key = Lists.languageList.someKey(forValue: languageTextField.text!) {
                    SelectedParameters.selectedLanguageToObtain = key
                }
            }
            if deviceTextField.text != "" {
                if let key = Lists.deviceList.someKey(forValue: deviceTextField.text!) {
                    SelectedParameters.selectedCurrency.currencyToObtain = key
                }
            }
            if cityResearch == true {
                print("rfirst print pour le true \(SelectedParameters.secondSelectedId)")
                SelectedParameters.selectedWeatherRightCity = currentWeather
                SelectedParameters.secondSelectedId = idLinkToCity
                print(SelectedParameters.secondSelectedId)
                print(SelectedParameters.selectedId)
            }
            print("print de fin pour le second element \(SelectedParameters.secondSelectedId)")
            print(SelectedParameters.selectedId)
            print("seco,nd print de fin pour le second element \(SelectedParameters.secondSelectedId)")
            succesMessage(element: "the second element")
        }
    }

    private func alertErrorMessage(message: String) {
        let alertVC = UIAlertController(title: "Error!", message: message,
                                        preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }

    private func succesMessage(element: String) {
        let alertVC = UIAlertController(title: "Success!", message: "The parameters are changed for \(element)!",
                                        preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }

    private func toggleActivityIndicator(shown: Bool) {
        activityIndicator.isHidden = !shown
        validateButton.isHidden = shown
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
            return Lists.listOfCities.count
        case 1:
            return Lists.deviceList.count
        case 2:
            return Lists.languageList.count
        default:
            return 1
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 0:
            let cityName = Lists.listOfCities[row].name
            let cityDevice = Lists.listOfCities[row].device
            let cityLanguage = Lists.listOfCities[row].language
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
            let cityName = Lists.listOfCities[row].name
            let cityDevice = Lists.listOfCities[row].device
            let cityLanguage = Lists.listOfCities[row].language
            suggestionTextField.text = "\(cityName), \(cityDevice), \(cityLanguage)"
            idLinkToPickerView = Lists.listOfCities[row].cityId
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
        var array: [String] = []
        for (_, currencyName) in Lists.deviceList {
            array.append(currencyName)
        }
        deviceNames = array.sorted()
    }

    private func selectLanguageNamesOnly() {
        var array: [String] = []
        for (_, languageName) in Lists.languageList {
            array.append(languageName)
        }
        languageNames = array.sorted()
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
