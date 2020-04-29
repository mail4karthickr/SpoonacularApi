//
//  RecipeResponseTests.swift
//  SpoonacularApiTests
//
//  Created by Karthick Ramasamy on 4/6/20.
//  Copyright © 2020 Karthick Ramasamy. All rights reserved.
//

import Foundation
import XCTest

class RecipeResponseTests: TestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    func testFilterRecipes() {
        let recipeResponse = MockService.getRandomRecipiesResponse()
        let expectedVegetarianRecipes = MockService.getVegetarianRecipieResponse().recipes
        let expectedDairyFreeRecipes = MockService.getDairyFreeRecipieResponse().recipes
        let expectedGlutenFreeRecipes = MockService.getGlutenFreeRecipieResponse().recipes

        let vegetarianRecipes = recipeResponse.filterRecipies(byFilterType: .vegetarian)
        let dairyFreeRecipes = recipeResponse.filterRecipies(byFilterType: .dairyFree)
        let glutenFreeRecipes = recipeResponse.filterRecipies(byFilterType: .glutenFree)
       
        XCTAssertEqual(vegetarianRecipes, expectedVegetarianRecipes)
        XCTAssertEqual(dairyFreeRecipes, expectedDairyFreeRecipes)
        XCTAssertEqual(glutenFreeRecipes, expectedGlutenFreeRecipes)
        XCTAssertEqual(recipeResponse.recipes, MockService.getRandomRecipiesResponse().recipes)
    }
}
