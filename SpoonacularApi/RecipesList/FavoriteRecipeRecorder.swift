//
//  FavoriteRecipeRecorder.swift
//  SpoonacularApi
//
//  Created by Karthick Ramasamy on 4/28/20.
//  Copyright © 2020 Karthick Ramasamy. All rights reserved.
//

import Foundation

protocol FavoriteRecipeRecorderType  {
    func saveFavoriteRecipe(cellData: RecipeListCellData)
    func allFavoriteRecipes() -> [RecipeListCellData]
    func recipeExists(cellData: RecipeListCellData) -> Bool
    func removeRecipe(cellData: RecipeListCellData)
}

class FavoriteRecipeRecorder: FavoriteRecipeRecorderType {
    private var favoritRecipes: [RecipeListCellData] = []
    
    func saveFavoriteRecipe(cellData: RecipeListCellData) {
        favoritRecipes.append(cellData)
    }
    
    func allFavoriteRecipes() -> [RecipeListCellData] {
        return favoritRecipes
    }
    
    func recipeExists(cellData: RecipeListCellData) -> Bool {
        favoritRecipes.filter { $0.recipe.id == cellData.recipe.id }
            .count > 0
    }
    
    func removeRecipe(cellData: RecipeListCellData) {
        let index = favoritRecipes.firstIndex { $0.recipe.id == cellData.recipe.id }
        guard let recipeIndex = index else {
            return
        }
        favoritRecipes.remove(at: recipeIndex)
    }
}
