//
//  Service.swift
//  SpoonacularApi
//
//  Created by Karthick Ramasamy on 4/10/20.
//  Copyright © 2020 Karthick Ramasamy. All rights reserved.
//

import Foundation
import RxSwift

enum NetworkError: Error {
    case serverNotReachable
    case decodingFailed
    case urlConstructionFailed
    case unknown
}

class Service: ServiceType {
    
    func getRandomRecipies() -> Observable<RecipeResponse> {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.spoonacular.com"
        urlComponents.path = "/recipes/random"
        let queryItemApiKey = URLQueryItem(name: "apiKey", value: "e702bb62ec6746ce9db7738d89805e7e")
        let queryItemNumber = URLQueryItem(name: "number", value: "15")
        urlComponents.queryItems = [queryItemApiKey, queryItemNumber]
        guard let url = urlComponents.url else {
            return .error(NetworkError.urlConstructionFailed)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "Get"
        return requestApi(urlrequest: request)
    }
    
    func requestApi<T: Codable>(urlrequest: URLRequest) -> Observable<T> {
        return Observable<T>.create { observer in
            let task = URLSession.shared.dataTask(with: urlrequest) { (data, response, error) in
                if let _ = error {
                    observer.onError(ApiError.networkNotAvailable)
                } else if let data = data {
                    do {
                        let model = try JSONDecoder().decode(T.self, from: data)
                        observer.onNext(model)
                    } catch {
                        observer.onError(ApiError.decodingFailed)
                    }
                } else {
                    observer.onError(ApiError.unknown)
                }
            }
            task.resume()
            return Disposables.create { task.cancel() }
        }
    }
}
