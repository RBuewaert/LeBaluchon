//
//  TranslationViewController.swift
//  LeBaluchon
//
//  Created by Romain Buewaert on 26/07/2021.
//

import UIKit

class TranslationViewController: UIViewController {
    var translation: Translation!

    @IBOutlet weak var languageToTranslateLabel: UILabel!
    @IBOutlet weak var languageToObtainLabel: UILabel!
    @IBOutlet weak var textToTranslateTextView: UITextView!
    @IBOutlet weak var resultTextView: UITextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var translateButton: UIButton!
    @IBOutlet weak var reverseButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        let toolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissMyKeyboard))
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        self.textToTranslateTextView.inputAccessoryView = toolbar

        TranslationService.shared.getTranslation(textToTranslate: "Bonjour", languageToTranslate: "fr", languageToObtain: "en") { success, translation in

            if success, let currentTranslation = translation {
                self.translation = currentTranslation
//                self.updateExchangeRateView(currency: currentCurrency)
                print(self.translation.textToObtain)
            } else {
                self.alertErrorMessage(message: ErrorType.downloadFailed.rawValue)
            }
        }

    }

    @objc func dismissMyKeyboard() {
        view.endEditing(true)
    }

    private func toggleActivityIndicator(shown: Bool) {
        activityIndicator.isHidden = !shown
        translateButton.isHidden = shown
        reverseButton.isHidden = shown
    }

    @IBAction func tappedReverseButton(_ sender: Any) {
    }

    @IBAction func tappedTranslateButton(_ sender: Any) {
    }

    private func alertErrorMessage(message: String) {
        let alertVC = UIAlertController(title: "Error!", message: message,
                                        preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
}

// MARK: - Keyboard
extension TranslationViewController: UITextViewDelegate {
    func textViewShouldReturn(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }

    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        languageToTranslateLabel.endEditing(true)
    }
}
