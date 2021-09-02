//
//  ExchangeRateViewController.swift
//  LeBaluchon
//
//  Created by Romain Buewaert on 26/07/2021.
//

import UIKit

final class ExchangeRateViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var comparedCurrencyLabel: UILabel!
    @IBOutlet weak var leftCurrencyLabel: UILabel!
    @IBOutlet weak var rightCurrencyLabel: UILabel!
    @IBOutlet weak var userValueTextField: UITextField!
    @IBOutlet weak var resultValueLabel: UILabel!
    @IBOutlet weak var convertButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    // MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit,
                                        target: self, action: #selector(launchParametersViewController))
        self.tabBarController?.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh,
                                        target: self, action: #selector(updateCurrentViewController))

        convertButton.layer.cornerRadius = 30

        CurrencyService.shared.getExchangeRate { (success, currency) in
            self.toggleActivityIndicator(shown: false)

            if success, let currentCurrency = currency {
                SelectedParameters.selectedCurrency.exchangeRate = currentCurrency.exchangeRate
                self.updateExchangeRateView(currency: currentCurrency)
                CurrencyService.shared.requestSuccess = true
            } else {
                self.alertErrorMessage(message: ErrorType.downloadFailed.rawValue)
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if CurrencyService.shared.requestSuccess == true {
            updateExchangeRateView(currency: SelectedParameters.selectedCurrency)
        }
    }

    // MARK: - Action
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

    // MARK: - Privates methods
    private func updateExchangeRateView(currency: Currency) {
        do {
            let currencyForOne: String = try CurrencyService.shared.convertCurrency(
                currency: currency,
                currencyToConvert: currency.currencyToConvert,
                currencyToObtain: currency.currencyToObtain,
                valueToConvert: "1")!
            guard let numberOneFormatter: String = CurrencyService.shared.formatterCurrencyCode(value: 1,
                        currency: SelectedParameters.selectedCurrency.currencyToConvert) else { return }

            comparedCurrencyLabel.text = """
                Today :

                \(numberOneFormatter) =  \(currencyForOne)
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

    private func toggleActivityIndicator(shown: Bool) {
        activityIndicator.isHidden = !shown
        convertButton.isHidden = shown
    }

    // MARK: - UIAlertController
    private func alertErrorMessage(message: String) {
        let alertVC = UIAlertController(title: "Error!", message: message,
                                        preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
}

// MARK: - Methods for NavigationItem Buttons
extension ExchangeRateViewController {
    @objc func launchParametersViewController() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let parametersViewController = storyBoard.instantiateViewController(
                withIdentifier: "Parameters") as? ParametersViewController else { return}
        self.present(parametersViewController, animated: true, completion: nil)
    }

    @objc func updateCurrentViewController() {
        updateExchangeRateView(currency: SelectedParameters.selectedCurrency)
    }
}

// MARK: - Keyboard for UITextFieldDelegate
extension ExchangeRateViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        userValueTextField.resignFirstResponder()
    }
}
