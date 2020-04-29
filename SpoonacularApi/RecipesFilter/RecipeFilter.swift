//
//  RecipeFilter.swift
//  SpoonacularApi
//
//  Created by Karthick Ramasamy on 4/19/20.
//  Copyright © 2020 Karthick Ramasamy. All rights reserved.
//

import Foundation

struct RecipeFilter {
    var vegetarian: Bool
    var vegan: Bool
    var glutenFree: Bool
    var dairyFree: Bool
    var veryHealthy: Bool
    var cheap: Bool
    var veryPopular: Bool
    
    static var `default`: RecipeFilter {
        return RecipeFilter(vegetarian: false,
                            vegan: false,
                            glutenFree: false,
                            dairyFree: false,
                            veryHealthy: false,
                            cheap: false,
                            veryPopular: false)
    }
    
    var activeFilters: [FilterType] {
       var filterTypes = [FilterType]()
        if (self.vegetarian) {
            filterTypes.append(.vegetarian)
        }
        if (self.vegan) {
            filterTypes.append(.vegan)
        }
        if (self.glutenFree) {
            filterTypes.append(.glutenFree)
        }
        if (self.dairyFree) {
            filterTypes.append(.dairyFree)
        }
        if (self.veryHealthy) {
            filterTypes.append(.veryHealthy)
        }
        if (self.cheap) {
            filterTypes.append(.cheap)
        }
        if (self.veryPopular) {
            filterTypes.append(.veryPopular)
        }
        return filterTypes
    }
}

extension RecipeFilter: Equatable {}
