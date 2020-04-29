//
//  RecipeListViewControllerTests.swift
//  SpoonacularApiTests
//
//  Created by Karthick Ramasamy on 4/28/20.
//  Copyright © 2020 Karthick Ramasamy. All rights reserved.
//

import Foundation
import RxSwift
import SnapshotTesting
import XCTest

class MockFavoriteRecipeRecorder: FavoriteRecipeRecorderType {
    func saveFavoriteRecipe(cellData: RecipeListCellData) {}
    
    func allFavoriteRecipes() -> [RecipeListCellData] {
        return []
    }
    
    func recipeExists(cellData: RecipeListCellData) -> Bool {
        if cellData.recipe.id == 635370 || cellData.recipe.id == 1408961 {
           return true
        }
        return false
    }
    
    func removeRecipe(cellData: RecipeListCellData) {}
}

func recipeListViewController() -> RecipesListViewController {
       let bundle = Bundle.init(for: RecipeListViewControllerTests.self)
       let storyboard = UIStoryboard(name: "Main", bundle: bundle)
       return storyboard.instantiateViewController(identifier: "RecipesListViewController") as! RecipesListViewController
   }
   
   func errorViewController() -> ErrorViewController {
       let bundle = Bundle.init(for: RecipeListViewControllerTests.self)
       let storyboard = UIStoryboard(name: "Main", bundle: bundle)
       return storyboard.instantiateViewController(identifier: "ErrorViewController") as! ErrorViewController
   }

class RecipeListViewControllerTests: TestCase {
    
    override func setUp() {
        super.setUp()
        UIView.setAnimationsEnabled(false)
    }
    
    override func tearDown() {
        UIView.setAnimationsEnabled(false)
        super.tearDown()
    }
    
    func testGetRecipes_en() {
        withEnvironment(apiService: MockService(), language: .en) {
            var iPhoneSEPortrait = ViewImageConfig.iPhoneSe(.portrait)
            iPhoneSEPortrait.size?.height = 1750
            var iPhoneXrPortrait = ViewImageConfig.iPhoneXr(.portrait)
            iPhoneXrPortrait.size?.height = 1750
            var iPhoneSELandscape = ViewImageConfig.iPhoneSe(.landscape)
            iPhoneSELandscape.size?.height = 1750
            var iPhoneXrLandscape = ViewImageConfig.iPhoneXr(.landscape)
            iPhoneXrLandscape.size?.height = 1750
                  
            assertSnapshot(matching: recipeListViewController(), as: .image(on: iPhoneSEPortrait), named: "iPhoneSe-Portrait")
            assertSnapshot(matching: recipeListViewController(), as: .image(on: iPhoneXrPortrait), named: "iPhoneXr-Portrait")
            assertSnapshot(matching: recipeListViewController(), as: .image(on: iPhoneSELandscape), named: "iPhoneSe-landscape")
            assertSnapshot(matching: recipeListViewController(), as: .image(on: iPhoneXrLandscape), named: "iPhoneXr-landscape")
        }
    }
    
    func testGetRecipes_es() {
        withEnvironment(apiService: MockService(), language: .es) {
            var iPhoneSEPortrait = ViewImageConfig.iPhoneSe(.portrait)
            iPhoneSEPortrait.size?.height = 1750
            var iPhoneXrPortrait = ViewImageConfig.iPhoneXr(.portrait)
            iPhoneXrPortrait.size?.height = 1750
            var iPhoneSELandscape = ViewImageConfig.iPhoneSe(.landscape)
            iPhoneSELandscape.size?.height = 1750
            var iPhoneXrLandscape = ViewImageConfig.iPhoneXr(.landscape)
            iPhoneXrLandscape.size?.height = 1750
                  
            assertSnapshot(matching: recipeListViewController(), as: .image(on: iPhoneSEPortrait), named: "iPhoneSe-Portrait")
            assertSnapshot(matching: recipeListViewController(), as: .image(on: iPhoneXrPortrait), named: "iPhoneXr-Portrait")
            assertSnapshot(matching: recipeListViewController(), as: .image(on: iPhoneSELandscape), named: "iPhoneSe-landscape")
            assertSnapshot(matching: recipeListViewController(), as: .image(on: iPhoneXrLandscape), named: "iPhoneXr-landscape")
        }
    }
    
    func testGetRecipesError_en() {
        withEnvironment(language: .en) {
            assertSnapshot(matching: errorViewController(), as: .image(on: .iPhoneSe), named: "iPhoneSe-Portrait")
            assertSnapshot(matching: errorViewController(), as: .image(on: .iPhoneXr), named: "iPhoneXr-Portrait")
            assertSnapshot(matching: errorViewController(), as: .image(on: .iPhoneSe(.landscape)), named: "iPhoneSe-landscape")
            assertSnapshot(matching: errorViewController(), as: .image(on: .iPhoneXr(.landscape)), named: "iPhoneXr-landscape")
        }
    }
    
    func testGetRecipesError_es() {
        withEnvironment(language: .es) {
            assertSnapshot(matching: errorViewController(), as: .image(on: .iPhoneSe), named: "iPhoneSe-Portrait")
            assertSnapshot(matching: errorViewController(), as: .image(on: .iPhoneXr), named: "iPhoneXr-Portrait")
            assertSnapshot(matching: errorViewController(), as: .image(on: .iPhoneSe(.landscape)), named: "iPhoneSe-landscape")
            assertSnapshot(matching: errorViewController(), as: .image(on: .iPhoneXr(.landscape)), named: "iPhoneXr-landscape")
        }
    }
}
