//
//  TranslationViewController.swift
//  LeBaluchon
//
//  Created by Romain Buewaert on 26/07/2021.
//

import UIKit

final class TranslationViewController: UIViewController {
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

        translateButton.layer.cornerRadius = 30
        reverseButton.layer.cornerRadius = 15

        translation = SelectedParameters.selectedTranslation

        let toolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissMyKeyboard))
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        self.textToTranslateTextView.inputAccessoryView = toolbar

        TranslationService.shared.getTranslation(textToTranslate: translation.textToTranslate,
                            languageToTranslate: translation.languageToTranslate,
                            languageToObtain: translation.languageToObtain) { success, translation in

            if success, let currentTranslation = translation {
                self.translation = currentTranslation
                self.updateTranslationView(translation: currentTranslation)
            } else {
                self.alertErrorMessage(message: ErrorType.downloadFailed.rawValue)
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        print("viewWillApear Google")
    }

    override func viewDidAppear(_ animated: Bool) {
        print("viewDidApear Google(seconde vue)")
    }

    @objc func dismissMyKeyboard() {
        view.endEditing(true)
    }

    private func toggleActivityIndicator(shown: Bool) {
        activityIndicator.isHidden = !shown
        translateButton.isHidden = shown
        reverseButton.isHidden = shown
    }

    private func updateTranslationView(translation: Translation) {
        languageToTranslateLabel.text = languageList[translation.languageToTranslate]
        languageToObtainLabel.text = languageList[translation.languageToObtain]
        resultTextView.text = translation.textToObtain
    }

    @IBAction func tappedReverseButton(_ sender: Any) {
        let originalText = textToTranslateTextView.text
        textToTranslateTextView.text = resultTextView.text
        resultTextView.text = originalText

        let originalLanguage = translation.languageToTranslate
        translation.languageToTranslate = translation.languageToObtain
        translation.languageToObtain = originalLanguage

        languageToTranslateLabel.text = languageList[translation.languageToTranslate]
        languageToObtainLabel.text = languageList[translation.languageToObtain]
    }

    @IBAction func tappedTranslateButton(_ sender: Any) {
        guard let textToTranslate = textToTranslateTextView.text else { return}
        print(textToTranslate)

        toggleActivityIndicator(shown: true)

        TranslationService.shared.getTranslation(
            textToTranslate: textToTranslate,
            languageToTranslate: translation.languageToTranslate,
            languageToObtain: translation.languageToObtain) { success, translation in

            self.toggleActivityIndicator(shown: false)

            if success, let currentTranslation = translation {
                self.translation = currentTranslation
                self.resultTextView.text = currentTranslation.textToObtain
                print(translation?.textToTranslate)
                print(translation?.textToObtain)
            } else {
                self.alertErrorMessage(message: ErrorType.downloadFailed.rawValue)
            }
        }
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

