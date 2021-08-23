//
//  Translation.swift
//  LeBaluchon
//
//  Created by Romain Buewaert on 23/08/2021.
//

import Foundation

struct Translation {
    let languageToConvert = "fr"
    let languageToObtain = "en"
    let textToConvert: String
    let textToObtain: String
}

struct TranslationResult: Codable {
    let data: TranslationResultText
}

struct TranslationResultText: Codable {
    let translations: [String: String]
}

/*
{
    "data": {
        "translations": [
            {
                "translatedText": "Hello, my name is Romain"
            }
        ]
    }
}
*/
