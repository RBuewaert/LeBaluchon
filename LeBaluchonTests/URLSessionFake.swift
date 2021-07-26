//
//  URLSessionFake.swift
//  LeBaluchonTests
//
//  Created by Romain Buewaert on 26/07/2021.
//

import Foundation

class URLSessionFake : URLSession {
    var data: Data?
    var response: URLResponse?
    var error: Error?

    init(data: Data?, response: URLResponse?, error: Error?) {
        self.data = data
        self.response = response
        self.error = error
    }

    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSessionDataTaskFake()
        task.completionHandler = completionHandler
        task.data = data
        task.urlResponse = response
        task.responseError = error
        return task
    }

//    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
//        let task = URLSessionDataTaskFake()
//        task.completionHandler = completionHandler
//        task.data = data
//        task.urlResponse = response
//        task.responseError = error
//        return task
//    }

}

class URLSessionDataTaskFake : URLSessionDataTask {
    var completionHandler: ((Data?, URLResponse?, Error?) -> Void)?

    var data: Data?
    var urlResponse: URLResponse?
    var responseError: Error?

    override func resume() {
        completionHandler?(data, urlResponse, responseError)
    }

    // Vide car on ne fera pas de vrai appel donc rien à stopper
    override func cancel() {}
}
