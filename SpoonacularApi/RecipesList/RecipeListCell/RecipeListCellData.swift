//
//  RecipeListCellData.swift
//  SpoonacularApi
//
//  Created by Karthick Ramasamy on 4/28/20.
//  Copyright © 2020 Karthick Ramasamy. All rights reserved.
//

import UIKit

enum StarRating: Double {
    case zero, one, two, three, four, five
}

struct RecipeListCellData {
    var recipe: Recipe
    
    var isFavorite: Bool {
        set {
            if newValue {
                AppEnvironment.current.recipeRecorder.saveFavoriteRecipe(cellData: self)
            } else {
                AppEnvironment.current.recipeRecorder.removeRecipe(cellData: self)
            }
        } get {
            return AppEnvironment.current.recipeRecorder.recipeExists(cellData: self)
        }
    }
    
    var favouriteButtonImage: UIImage {
        let fillImage = UIImage(named: "fav_fill.png", in: AppEnvironment.current.bundle, with: nil)!
        let outLineImage = UIImage(named: "fav_outline.png", in: AppEnvironment.current.bundle, with: nil)!
        return isFavorite ? fillImage : outLineImage
    }
    
    var rating: StarRating {
        switch self.recipe.spoonacularScore {
        case (0 ... 20):
            return .one
        case (20 ... 40):
            return .two
        case (40 ... 60):
            return .three
        case (60 ... 80):
            return .four
        case 80...:
            return .five
        default:
            return .zero
        }
    }
}

extension RecipeListCellData: Equatable {
    static func == (lhs: RecipeListCellData, rhs: RecipeListCellData) -> Bool {
        return lhs.recipe == rhs.recipe &&
            lhs.isFavorite == rhs.isFavorite &&
            lhs.favouriteButtonImage == rhs.favouriteButtonImage &&
            lhs.rating == rhs.rating
    }
}
