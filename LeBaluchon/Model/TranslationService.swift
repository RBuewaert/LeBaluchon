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
    
    
}
