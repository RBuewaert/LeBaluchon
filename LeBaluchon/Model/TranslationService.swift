//
//  TranslationService.swift
//  LeBaluchon
//
//  Created by Romain Buewaert on 23/08/2021.
//

import Foundation

class TranslationService {
    // MARK: - Pattern Singleton
    static var shared = TranslationService()
    private init() {}

    // MARK: - Dependency injection
    private var task: URLSessionDataTask?
    private var translationSession = URLSession(configuration: .default)

    init(translationSession: URLSession) {
        self.translationSession = translationSession
    }

    private static let baseTranslationUrl = "https://translation.googleapis.com/language/translate/v2?q="

    func getTranslation(textToTranslate: String, languageToTranslate: String, languageToObtain: String, callback: @escaping (Bool, Translation?) -> Void) {
        let languageSource = "&source=" + languageToTranslate
        let languageTarget = "&target=" + languageToObtain
        let urlParameters = textToTranslate + languageSource + languageTarget + "&key=" + keyGoogleTranslate

        guard let url = URL(string: TranslationService.baseTranslationUrl + urlParameters) else {
            callback(false, nil)
            return
        }

        task?.cancel()
        task = translationSession.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(false, nil)
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, nil)
                    return
                }
                // Extract property indicated in Struct TranslationResult
                guard let result = try? JSONDecoder().decode(TranslationResult.self, from: data) else {
                    return callback(false, nil)
                }

                let translation = Translation(textToTranslate: textToTranslate, textToObtain: result.data.translations[0].translatedText)
                callback(true, translation)
            }
        }
        task?.resume()
    }
    
}
