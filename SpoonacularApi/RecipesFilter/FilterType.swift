//
//  FilterType.swift
//  SpoonacularApi
//
//  Created by Karthick Ramasamy on 4/19/20.
//  Copyright © 2020 Karthick Ramasamy. All rights reserved.
//

import Foundation

enum FilterType: String {
    case vegetarian
    case vegan
    case glutenFree
    case dairyFree
    case veryHealthy
    case cheap
    case veryPopular
}

extension FilterType: Hashable {}

extension FilterType: Equatable {
    static func == (lhs: FilterType, rhs: FilterType) -> Bool {
        switch (lhs, rhs) {
        case (.vegetarian, vegetarian),
             (.vegan, .vegan),
             (.glutenFree, .glutenFree),
             (.dairyFree, .dairyFree),
             (.veryHealthy, veryHealthy),
             (.cheap, .cheap),
             (.veryPopular, .veryPopular):
            return true
        default:
            return false
        }
    }
}
