//
//  ServiceType.swift
//  SpoonacularApi
//
//  Created by Karthick Ramasamy on 3/30/20.
//  Copyright © 2020 Karthick Ramasamy. All rights reserved.
//

import Foundation
import RxSwift

enum ApiError: Error {
    case decodingFailed
    case networkNotAvailable
    case unknown
}

protocol ServiceType {
    func getRandomRecipies() -> Observable<RecipeResponse>
}

class MockService: ServiceType {
    var randomRecipiesResponse: RecipeResponse?
    var randomRecipiesError: ApiError?
    
    init(randomRecipiesResponse: RecipeResponse? = nil,
         randomRecipiesError: ApiError? = nil) {
        self.randomRecipiesResponse = randomRecipiesResponse
        self.randomRecipiesError = randomRecipiesError
    }
    
    func getRandomRecipies() -> Observable<RecipeResponse> {
        if let randomRecipiesResponse = self.randomRecipiesResponse {
            return .just(randomRecipiesResponse)
        } else if let randomRecipiesError = self.randomRecipiesError {
            return Observable.error(randomRecipiesError)
        } else {
            return .just(MockService.getRandomRecipiesResponse())
        }
    }
    
    public static func getRandomRecipiesResponse() -> RecipeResponse {
        return MockService.getMockData(fileName: "RandomRecipies")!
    }
    
    public static func getDairyFreeRecipieResponse() -> RecipeResponse {
        return MockService.getMockData(fileName: "DairyFreeRecipies")!
    }
    
    public static func getGlutenFreeRecipieResponse() -> RecipeResponse {
        return MockService.getMockData(fileName: "GlutenFreeRecipies")!
    }
    
    public static func getVegetarianRecipieResponse() -> RecipeResponse {
        return MockService.getMockData(fileName: "VegetarianRecipies")!
    }

    public static func getFilterType1Recipes() -> [Recipe] {
        let recipeResponse: RecipeResponse = MockService.getMockData(fileName: "FilterType-1")!
        return recipeResponse.recipes
    }

    public static func getMockData<T: Codable>(fileName: String) -> T? {
        let bundle = Bundle(for: MockService.self)
        guard let filePath = bundle.url(forResource: fileName, withExtension: "json") else {
            return nil
        }
        do {
            let data = try Data(contentsOf: filePath)
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
        } catch {
            return nil
        }
    }
}
