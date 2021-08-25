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

    @IBOutlet weak var firstSuggestionPickerView: UIPickerView!
    @IBOutlet weak var secondSuggestionPickerView: UIPickerView!
    @IBOutlet weak var firstDevicePickerView: UIPickerView!
    @IBOutlet weak var secondDevicePickerView: UIPickerView!
    @IBOutlet weak var firstLanguagePickerView: UIPickerView!
    @IBOutlet weak var secondLanguagePickerView: UIPickerView!
    @IBOutlet weak var firstCityTextField: UITextField!
    @IBOutlet weak var secondCityTextField: UITextField!
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func tappedResetButton(_ sender: Any) {
    }

    @IBAction func tappedValidateButton(_ sender: Any) {
    }
    
    
    

}
