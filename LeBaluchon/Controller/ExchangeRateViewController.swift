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
    @IBOutlet weak var leftCurrencyLabel: UILabel!
    @IBOutlet weak var rightCurrencyLabel: UILabel!
    @IBOutlet weak var userValueTextField: UITextField!
    @IBOutlet weak var resultValueLabel: UILabel!
    @IBOutlet weak var convertButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(changeParameters))

//        navigationItem.titleView?.isHidden = false
//        navigationItem.title = "titi"
//        self.tabBarController?.navigationItem.title = "Exchange Rate"
//        navigationController?.title = "Exchange Rate"
//        navigationItem.title = "Exchange Rate"
//        navigationController?.navigationBar.prefersLargeTitles = true

        convertButton.layer.cornerRadius = 30

//        CurrencyService.shared.getExchangeRate { (success, currency) in
//                    self.toggleActivityIndicator(shown: false)
//
//                    if success, let currentCurrency = currency {
//                        self.currency = currentCurrency
//                        self.updateExchangeRateView(currency: currentCurrency)
//                    } else {
//                        self.alertErrorMessage(message: ErrorType.downloadFailed.rawValue)
//                    }
//                }
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

            let currencyToConvertName = currencyList[currency.currencyToConvert]
            let currencyToObtainName = currencyList[currency.currencyToObtain]

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
                currency: currency,
                currencyToConvert: currency.currencyToConvert,
                currencyToObtain: currency.currencyToObtain,
                valueToConvert: userValueTextField.text)

        } catch ErrorType.userValueIsIncorrect {
            alertErrorMessage(message: ErrorType.userValueIsIncorrect.rawValue)
        } catch ErrorType.firstCurrencyIsIncorrect {
            alertErrorMessage(message: ErrorType.firstCurrencyIsIncorrect.rawValue)
        } catch {
            alertErrorMessage(message: ErrorType.secondCurrencyIsIncorrect.rawValue)
        }
    }

    @objc func changeParameters() {
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
