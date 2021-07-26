//
//  ExchangeRateViewController.swift
//  LeBaluchon
//
//  Created by Romain Buewaert on 26/07/2021.
//

import UIKit

class ExchangeRateViewController: UIViewController {
    var currency: Currency!

    @IBOutlet weak var comparedCurrencyLabel: UILabel!
    @IBOutlet weak var firstCurrencyLabel: UILabel!
    @IBOutlet weak var secondCurrencyLabel: UILabel!
    @IBOutlet weak var userValueTextField: UITextField!
    @IBOutlet weak var resultValueLabel: UILabel!
    @IBOutlet weak var convertButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        CurrencyService.shared.getExchangeRate { (success, currency) in
                    self.toggleActivityIndicator(shown: false)

                    if success, let currentCurrency = currency {
                        self.currency = currentCurrency
                        self.update(currency: currentCurrency)
                        print(self.currency.exchangeRate)
                    } else {
                        self.errorMessage(message: ErrorType.downloadFailed.rawValue)
                    }
                }
    }

    private func toggleActivityIndicator(shown: Bool) {
            activityIndicator.isHidden = !shown
            convertButton.isHidden = shown
        }

    private func update(currency: Currency) {
        do {
            let currencyForOne: String = try CurrencyService.shared.convertCurrency(
                currency: currency,
                currencyToConvert: currency.currencyToConvert,
                currencyToObtain: currency.currencyToObtain,
                valueToConvert: "1")!

            comparedCurrencyLabel.text = """
                Today :

                1 \(currencyList[currency.currencyToConvert]!) =  \(currencyForOne) \(currencyList[currency.currencyToObtain]!)
                """
            firstCurrencyLabel.text = """
                Enter your value:
                in \(currency.currencyToConvert)
                """
            secondCurrencyLabel.text = """
                Result:
                in \(currency.currencyToObtain)
                """
            resultValueLabel.text = currencyForOne

        } catch ErrorType.userValueIsIncorrect {
            errorMessage(message: ErrorType.userValueIsIncorrect.rawValue)
        } catch ErrorType.firstCurrencyIsIncorrect {
            errorMessage(message: ErrorType.firstCurrencyIsIncorrect.rawValue)
        } catch {
            errorMessage(message: ErrorType.secondCurrencyIsIncorrect.rawValue)
        }
    }

    private func errorMessage(message: String) {
        let alertVC = UIAlertController(title: "Error!", message: message,
                                        preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }

    @IBAction func tappedConvertButton() {
        do {
            resultValueLabel.text = try CurrencyService.shared.convertCurrency(
                currency: currency,
                currencyToConvert: currency.currencyToConvert,
                currencyToObtain: currency.currencyToObtain,
                valueToConvert: userValueTextField.text)

        } catch ErrorType.userValueIsIncorrect {
            errorMessage(message: ErrorType.userValueIsIncorrect.rawValue)
        } catch ErrorType.firstCurrencyIsIncorrect {
            errorMessage(message: ErrorType.firstCurrencyIsIncorrect.rawValue)
        } catch {
            errorMessage(message: ErrorType.secondCurrencyIsIncorrect.rawValue)
        }
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
