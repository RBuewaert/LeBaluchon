//
//  Translation.swift
//  LeBaluchon
//
//  Created by Romain Buewaert on 23/08/2021.
//

import Foundation

// MARK: - Struct for Translation
struct Translation {
    var languageToTranslate = "fr"
    var languageToObtain = "en"
    var textToTranslate: String
    var textToObtain: String
}

// MARK: - Struct result from JSO
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
