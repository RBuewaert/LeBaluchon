//
//  ParametersViewController.swift
//  LeBaluchon
//
//  Created by Romain Buewaert on 24/08/2021.
//

import UIKit

final class ParametersViewController: UIViewController {
    // MARK: - Properties
    var currentWeather: Weather!
    var cityResearch = false
    var idLinkToPickerView = 0
    var deviceLinkToPickerView = ""
    var languageLinkToPickerView = ""
    var nameLinkToPickerView = ""
    var idLinkToCitySearched = 0
    var deviceNames: [String] = []
    var languageNames: [String] = []
    var suggestedCities: [String] = []
    var suggestionPickerView = UIPickerView()
    var devicePickerView = UIPickerView()
    var languagePickerView = UIPickerView()

    // MARK: - Outlets
    @IBOutlet weak var suggestionTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var languageTextField: UITextField!
    @IBOutlet weak var deviceTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var validateButton: UIButton!

    // MARK: - Overrides
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

    // MARK: - Actions
    @IBAction func tappedValidateButton(_ sender: Any) {
        toggleActivityIndicator(shown: true)

        if suggestionTextField.text == "" && languageTextField.text == "" && deviceTextField.text == "" && cityTextField.text == "" {
            toggleActivityIndicator(shown: false)
            alertErrorMessage(message: ErrorType.noValue.rawValue)
        }
        if cityTextField.text != nil && cityTextField.text != "" {
            checkCityName(cityTapped: cityTextField)
        } else {
            extractValues()
            toggleActivityIndicator(shown: false)
        }
    }

    // MARK: - Private methods
    private func initializePickerView(pickerView: UIPickerView) {
        pickerView.delegate = self
        pickerView.dataSource = self
    }

    private func checkCityName(cityTapped: UITextField) {
        WeatherService.shared.getWeatherCity(city: cityTapped.text!) { success, weather in
            if success, let currentWeather = weather {
                self.currentWeather = currentWeather
                self.idLinkToCitySearched = currentWeather.id
                self.cityResearch = true
                self.extractValues()
                self.toggleActivityIndicator(shown: false)
            } else if WeatherService.shared.cityIsFound == false {
                self.cityResearch = false
                self.toggleActivityIndicator(shown: false)
                self.alertErrorMessage(message: ErrorType.cityNotFound.rawValue)
            } else {
                self.cityResearch = false
                self.toggleActivityIndicator(shown: false)
                self.alertErrorMessage(message: ErrorType.downloadFailed.rawValue)
            }
        }
    }

    private func extractValues() {
        if segmentControl.selectedSegmentIndex == 0 {
            extractValuesForFirstSelectedSegment()
        } else { // segmentControl.selectedSegmentIndex == 1
            extractValuesForSecondSelectedSegment()
        }
    }

    private func extractValuesForFirstSelectedSegment() {
        if suggestionTextField.text != "" {
            extractValueForFirstSuggestion()
        }
        if languageTextField.text != "" {
            if let key = Lists.languageList.someKey(forValue: languageTextField.text!) {
                SelectedParameters.selectedLanguageToTranslate = key
                SelectedParameters.selectedTranslation.languageToTranslate = key
            }
            toggleActivityIndicator(shown: true)
            TranslationService.shared.getTranslation(
                textToTranslate: "Bonjour",
                languageToTranslate: "fr",
                languageToObtain: SelectedParameters.selectedTranslation.languageToTranslate) { success, translation in
                if success, let currentTranslation = translation {
                    self.toggleActivityIndicator(shown: false)
                    SelectedParameters.selectedTranslation.textToTranslate = currentTranslation.textToObtain
                } else {
                    self.toggleActivityIndicator(shown: false)
                    self.alertErrorMessage(message: ErrorType.downloadFailed.rawValue)
                }
            }
        }
        if deviceTextField.text != "" {
            if let key = Lists.deviceList.someKey(forValue: deviceTextField.text!) {
                SelectedParameters.selectedCurrency.currencyToConvert = key
            }
        }
        if cityResearch == true {
            SelectedParameters.selectedWeatherLeftCity = currentWeather
            SelectedParameters.firstSelectedId = idLinkToCitySearched
        }
        succesMessage(element: "the first element")
    }

    private func extractValuesForSecondSelectedSegment() {
        if suggestionTextField.text != "" {
            extractValueForSecondSuggestion()
        }
        if languageTextField.text != "" {
            if let key = Lists.languageList.someKey(forValue: languageTextField.text!) {
                SelectedParameters.selectedLanguageToObtain = key
                SelectedParameters.selectedTranslation.languageToObtain = key
            }
            toggleActivityIndicator(shown: true)
            TranslationService.shared.getTranslation(
                textToTranslate: SelectedParameters.selectedTranslation.textToTranslate,
                languageToTranslate: SelectedParameters.selectedTranslation.languageToTranslate,
                languageToObtain: SelectedParameters.selectedTranslation.languageToObtain) { success, translation in
                if success, let currentTranslation = translation {
                    self.toggleActivityIndicator(shown: false)
                    SelectedParameters.selectedTranslation.textToObtain = currentTranslation.textToObtain
                } else {
                    self.toggleActivityIndicator(shown: false)
                    self.alertErrorMessage(message: ErrorType.downloadFailed.rawValue)
                }
            }
        }
        if deviceTextField.text != "" {
            if let key = Lists.deviceList.someKey(forValue: deviceTextField.text!) {
                SelectedParameters.selectedCurrency.currencyToObtain = key
            }
        }
        if cityResearch == true {
            SelectedParameters.selectedWeatherRightCity = currentWeather
            SelectedParameters.secondSelectedId = idLinkToCitySearched
        }
        succesMessage(element: "the second element")
    }

    private func extractValueForFirstSuggestion() {
        SelectedParameters.selectedCurrency.currencyToConvert = deviceLinkToPickerView
        if let key = Lists.languageList.someKey(forValue: languageLinkToPickerView) {
            SelectedParameters.selectedLanguageToTranslate = key
            SelectedParameters.selectedTranslation.languageToTranslate = key
        }
        toggleActivityIndicator(shown: true)
        TranslationService.shared.getTranslation(
            textToTranslate: "Bonjour",
            languageToTranslate: "fr",
            languageToObtain: SelectedParameters.selectedTranslation.languageToTranslate) { success, translation in
            if success, let currentTranslation = translation {
                self.toggleActivityIndicator(shown: false)
                SelectedParameters.selectedTranslation.textToTranslate = currentTranslation.textToObtain
            } else {
                self.toggleActivityIndicator(shown: false)
                self.alertErrorMessage(message: ErrorType.downloadFailed.rawValue)
            }
        }
        SelectedParameters.firstSelectedId = idLinkToPickerView
        toggleActivityIndicator(shown: true)
        WeatherService.shared.getWeatherCity(city: nameLinkToPickerView) { success, weather in
            if success, let currentWeather = weather {
                SelectedParameters.selectedWeatherLeftCity = currentWeather
                self.toggleActivityIndicator(shown: false)
            } else {
                self.cityResearch = false
                self.alertErrorMessage(message: ErrorType.downloadFailed.rawValue)
            }
        }
        succesMessage(element: "the first element")
        return
    }

    private func extractValueForSecondSuggestion() {
        SelectedParameters.selectedCurrency.currencyToObtain = deviceLinkToPickerView
        if let key = Lists.languageList.someKey(forValue: languageLinkToPickerView) {
            SelectedParameters.selectedLanguageToObtain = key
            SelectedParameters.selectedTranslation.languageToObtain = key
        }
        toggleActivityIndicator(shown: true)
        TranslationService.shared.getTranslation(
            textToTranslate: SelectedParameters.selectedTranslation.textToTranslate,
            languageToTranslate: SelectedParameters.selectedTranslation.languageToTranslate,
            languageToObtain: SelectedParameters.selectedTranslation.languageToObtain) { success, translation in
            if success, let currentTranslation = translation {
                self.toggleActivityIndicator(shown: false)
                SelectedParameters.selectedTranslation.textToObtain = currentTranslation.textToObtain
            } else {
                self.toggleActivityIndicator(shown: false)
                self.alertErrorMessage(message: ErrorType.downloadFailed.rawValue)
            }
        }
        SelectedParameters.secondSelectedId = idLinkToPickerView
        toggleActivityIndicator(shown: true)
        WeatherService.shared.getWeatherCity(city: nameLinkToPickerView) { success, weather in
            if success, let currentWeather = weather {
                SelectedParameters.selectedWeatherRightCity = currentWeather
                self.toggleActivityIndicator(shown: false)
            } else {
                self.cityResearch = false
                self.alertErrorMessage(message: ErrorType.downloadFailed.rawValue)
            }
        }
        succesMessage(element: "the second element")
        return
    }

    private func toggleActivityIndicator(shown: Bool) {
        activityIndicator.isHidden = !shown
        validateButton.isHidden = shown
    }

    // MARK: - UIAlertController
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
}

// MARK: - Keyboard for UITextFieldDelegate
extension ParametersViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textView: UITextField) -> Bool {
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
            nameLinkToPickerView = cityName
            deviceLinkToPickerView = cityDevice
            languageLinkToPickerView = cityLanguage
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

    // MARK: - PickerView: Private methods
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
