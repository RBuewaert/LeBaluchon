//
//  ExchangeRateViewController.swift
//  LeBaluchon
//
//  Created by Romain Buewaert on 26/07/2021.
//

import UIKit

final class ExchangeRateViewController: UIViewController {
    var currency: Currency!
    var requestSuccess = false

    @IBOutlet weak var comparedCurrencyLabel: UILabel!
    @IBOutlet weak var leftCurrencyLabel: UILabel!
    @IBOutlet weak var rightCurrencyLabel: UILabel!
    @IBOutlet weak var userValueTextField: UITextField!
    @IBOutlet weak var resultValueLabel: UILabel!
    @IBOutlet weak var convertButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(launchParametersViewController))

        convertButton.layer.cornerRadius = 30

        currency = SelectedParameters.selectedCurrency

        CurrencyService.shared.getExchangeRate { (success, currency) in
            self.toggleActivityIndicator(shown: false)

            if success, let currentCurrency = currency {
                SelectedParameters.selectedCurrency.exchangeRate = currentCurrency.exchangeRate
                self.updateExchangeRateView(currency: currentCurrency)
                self.requestSuccess = true
            } else {
                self.alertErrorMessage(message: ErrorType.downloadFailed.rawValue)
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        if requestSuccess == true {
            print(SelectedParameters.selectedCurrency)
            print(SelectedParameters.selectedCurrency.exchangeRate)
//            currency = SelectedParameters.selectedCurrency
            print(SelectedParameters.selectedCurrency)
            print(SelectedParameters.selectedCurrency.exchangeRate)
            updateExchangeRateView(currency: SelectedParameters.selectedCurrency)
        }
//        updateExchangeRateView(currency: currency)
    }

    private func toggleActivityIndicator(shown: Bool) {
        activityIndicator.isHidden = !shown
        convertButton.isHidden = shown
    }

    private func updateExchangeRateView(currency: Currency) {
        do {
            let currencyForOne: String = try CurrencyService.shared.convertCurrency(
                currency: currency,
                currencyToConvert: currency.currencyToConvert,
                currencyToObtain: currency.currencyToObtain,
                valueToConvert: "1")!

            let currencyToConvertName = deviceList[currency.currencyToConvert]
            let currencyToObtainName = deviceList[currency.currencyToObtain]

            comparedCurrencyLabel.text = """
                Today :

                1 \(currencyToConvertName!) =  \(currencyForOne) \(currencyToObtainName!)
                """
            leftCurrencyLabel.text = """
                Enter your value:
                in \(currency.currencyToConvert)
                """
            rightCurrencyLabel.text = """
                Result:
                in \(currency.currencyToObtain)
                """
            resultValueLabel.text = currencyForOne

        } catch ErrorType.userValueIsIncorrect {
            alertErrorMessage(message: ErrorType.userValueIsIncorrect.rawValue)
        } catch ErrorType.firstCurrencyIsIncorrect {
            alertErrorMessage(message: ErrorType.firstCurrencyIsIncorrect.rawValue)
        } catch {
            alertErrorMessage(message: ErrorType.secondCurrencyIsIncorrect.rawValue)
        }
    }

    private func alertErrorMessage(message: String) {
        let alertVC = UIAlertController(title: "Error!", message: message,
                                        preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }

    @IBAction func tappedConvertButton() {
        do {
            resultValueLabel.text = try CurrencyService.shared.convertCurrency(
                currency: SelectedParameters.selectedCurrency,
                currencyToConvert: SelectedParameters.selectedCurrency.currencyToConvert,
                currencyToObtain: SelectedParameters.selectedCurrency.currencyToObtain,
                valueToConvert: userValueTextField.text)

        } catch ErrorType.userValueIsIncorrect {
            alertErrorMessage(message: ErrorType.userValueIsIncorrect.rawValue)
        } catch ErrorType.firstCurrencyIsIncorrect {
            alertErrorMessage(message: ErrorType.firstCurrencyIsIncorrect.rawValue)
        } catch {
            alertErrorMessage(message: ErrorType.secondCurrencyIsIncorrect.rawValue)
        }
    }

    @objc func launchParametersViewController() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let parametersViewController = storyBoard.instantiateViewController(withIdentifier: "Parameters") as? ParametersViewController else { return}
        self.present(parametersViewController, animated: true, completion: nil)
    }
}

// MARK: - Keyboard
extension ExchangeRateViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        userValueTextField.resignFirstResponder()
    }
}

extension ExchangeRateViewController {

}
