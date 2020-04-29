//
//  RecipiesResponse.swift
//  SpoonacularApi
//
//  Created by Karthick Ramasamy on 3/30/20.
//  Copyright © 2020 Karthick Ramasamy. All rights reserved.
//

import UIKit

struct RecipeResponse: Codable, Equatable {
    var recipes: [Recipe]
    
    func filterRecipies(byFilterType type: FilterType) -> [Recipe] {
        return filterBy(type: type, recipes: self.recipes)
    }
    
    func filterRecipies(byFilters filters: [FilterType]) -> [Recipe] {
        var recipes = self.recipes
        for filter in filters {
            recipes = filterBy(type: filter, recipes: recipes)
        }
        return recipes
    }
    
    private func filterBy(type: FilterType, recipes: [Recipe]) -> [Recipe] {
        switch type {
        case .dairyFree:
            return recipes.filter { $0.dairyFree }
        case .glutenFree:
            return recipes.filter { $0.glutenFree }
        case .vegetarian:
            return recipes.filter { $0.vegetarian }
        case .veryHealthy:
            return recipes.filter { $0.veryHealthy }
        case .veryPopular:
            return recipes.filter { $0.veryPopular }
        case .vegan:
            return recipes.filter { $0.vegan }
        case .cheap:
            return recipes.filter { $0.cheap }
        }
    }
}

struct Recipe: Codable, Equatable {
    let id: Int
    let vegetarian: Bool
    let vegan: Bool
    let glutenFree: Bool
    let dairyFree: Bool
    let veryHealthy: Bool
    let cheap: Bool
    let veryPopular: Bool
    let weightWatcherSmartPoints: Float
    let aggregateLikes: Int
    let spoonacularScore: Int
    let healthScore: Int
    let title: String
    let author: String?
    let readyInMinutes: Int
    let image: String?
    let summary: String?
    let cuisines: [String]?
    let pricePerServing: Float
}
