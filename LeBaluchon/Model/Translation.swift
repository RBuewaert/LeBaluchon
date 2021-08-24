//
//  Translation.swift
//  LeBaluchon
//
//  Created by Romain Buewaert on 23/08/2021.
//

import Foundation

struct Translation {
    let languageToTranslate = "fr"
    let languageToObtain = "en"
    let textToTranslate: String
    let textToObtain: String
}

struct TranslationResult: Codable {
    let data: TranslationResultData
}

struct TranslationResultData: Codable {
    let translations: [TranslationResultText]
}

struct TranslationResultText: Codable {
    let translatedText: String
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
