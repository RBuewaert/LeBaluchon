//
//  Translation.swift
//  LeBaluchon
//
//  Created by Romain Buewaert on 23/08/2021.
//

import Foundation

// MARK: - Struct for Translation
struct Translation {
    let languageToTranslate = "fr"
    let languageToObtain = "en"
    let textToTranslate: String
    let textToObtain: String
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

// MARK: - List of Language
let languageList = ["af": "Afrikaans",
                    "sq": "Albanian",
                    "am": "Amharic",
                    "ar": "Arabic",
                    "hy": "Armenian",
                    "az": "Azerbaijani",
                    "eu": "Basque",
                    "be": "Belarusian",
                    "bn": "Bengali",
                    "bs": "Bosnian",
                    "bg": "Bulgarian",
                    "ca": "Catalan",
                    "ceb": "Cebuano",
                    "zh-CN": "Chinese (Simplified)",
                    "zh-TW": "Chinese (traditional)",
                    "co": "Corsica",
                    "hr": "Croatian",
                    "cs": "Czech",
                    "da": "Danish",
                    "nl": "Dutch",
                    "en": "English",
                    "eo": "Esperanto",
                    "et": "Estonian",
                    "fi": "Finnish",
                    "fr": "French",
                    "fy": "Frisian",
                    "gl": "Galician",
                    "ka": "Georgian",
                    "de": "German",
                    "el": "Greek",
                    "gu": "Gujarati",
                    "ht": "Haitian Creole",
                    "ha": "Hausa",
                    "haw": "Hawaiian",
                    "he": "Hebrew",
                    "hi": "Hindi",
                    "hmn": "Hmong",
                    "hu": "Hungarian",
                    "is": "Icelandic",
                    "ig": "Igbo",
                    "id": "Indonesian",
                    "ga": "Irish",
                    "it": "Italian",
                    "ja": "Japanese",
                    "jv": "Javanese",
                    "kn": "Kannada",
                    "kk": "Kazakh",
                    "km": "Khmer",
                    "rw": "Kinyarwanda",
                    "ko": "Korean",
                    "ku": "Kurdish",
                    "ky": "Kyrgyz",
                    "lo": "Laotian",
                    "lv": "Latvian",
                    "lt": "Lithuanian",
                    "lb": "Luxembourgish",
                    "mk": "Macedonian",
                    "mg": "Malagasy",
                    "ms": "Malay",
                    "ml": "Malayâlam",
                    "mt": "Maltese",
                    "mi": "Maori",
                    "mr": "Marathi",
                    "mn": "Mongolian",
                    "my": "Burmese",
                    "ne": "Nepali",
                    "no": "Norwegian",
                    "ny": "Nyanja (Chichewa)",
                    "or": "Odia (Oriya)",
                    "ps": "Pashto",
                    "fa": "Persian",
                    "pl": "Polish",
                    "pt": "Portuguese",
                    "pa": "Panjabi",
                    "ro": "Romanian",
                    "ru": "Russian",
                    "sm": "Samoan",
                    "gd": "Gaelic",
                    "sr": "Serbian",
                    "st": "Sesotho",
                    "sn": "Shona",
                    "sd": "Sindhi",
                    "si": "Singhalese",
                    "sk": "Slovak",
                    "sl": "Slovenian",
                    "so": "Somali",
                    "es": "Spanish",
                    "su": "Soundanese",
                    "sw": "Swahili",
                    "sv": "Swedish",
                    "tl": "Tagalog (Filipino)",
                    "tg": "Tajik",
                    "ta": "Tamil",
                    "tt": "Tatar",
                    "te": "Telougou",
                    "th": "Thai",
                    "tr": "Turkish",
                    "tk": "Turkmen",
                    "uk": "Ukrainian",
                    "ur": "Urdu",
                    "ug": "Uyghur",
                    "uz": "Uzbek",
                    "vi": "Vietnamese",
                    "cy": "Welsh",
                    "xh": "Xhosa",
                    "yi": "Yiddish",
                    "yo": "Yoruba",
                    "zu": "Zulu"]

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
