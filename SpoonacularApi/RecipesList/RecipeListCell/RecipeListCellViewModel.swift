//
//  RecipeListCellViewModel.swift
//  SpoonacularApi
//
//  Created by Karthick Ramasamy on 4/28/20.
//  Copyright © 2020 Karthick Ramasamy. All rights reserved.
//

import Foundation
import RxSwift

protocol RecipesListCellViewModelInputs {
    func configureWith(recipe: Recipe)
    var recipeTapped: AnyObserver<Void> { get }
    var favoriteButton: AnyObserver<Void> { get }
}

protocol RecipesListCellViewModelOutputs {
    var favoriteIcon: Observable<UIImage> { get }
    var rating: Observable<StarRating> { get }
    var title: Observable<String> { get }
    var imageUrl: Observable<String> { get }
    var price: Observable<String> { get }
    var likes: Observable<String> { get }
}

protocol RecipesListCellViewModelType {
    var inputs: RecipesListCellViewModelInputs { get }
    var outputs: RecipesListCellViewModelOutputs { get }
}

class RecipesListCellViewModel: RecipesListCellViewModelType, RecipesListCellViewModelInputs, RecipesListCellViewModelOutputs {

    init() {
        
        let recipe = recipeSubject.map { RecipeListCellData(recipe: $0) }
        
        let modifiedRecipe = favoriteButtonTappedSubject.withLatestFrom(recipe) { _, recipe -> RecipeListCellData in
            var recipe = recipe
            recipe.isFavorite = !recipe.isFavorite
            return recipe
        }
        
        let cellData = Observable.merge(recipe, modifiedRecipe).share()
        
        self.favoriteIcon = cellData.map { $0.favouriteButtonImage }
               
        self.rating = cellData.map { $0.rating }
        
        self.title = cellData.map { $0.recipe.title }
        
        self.price = cellData.map { $0.recipe.pricePerServing }
            .map {
                print("Current Lan -- \(AppEnvironment.current.language)")
                return AppEnvironment.current.language == .en ? "Price: \($0)" :
                "Precio: \($0)"
            }
        
        self.likes = cellData.map { $0.recipe.aggregateLikes }
        .map {
            print("Current Lan -- \(AppEnvironment.current.language)")
            let val = AppEnvironment.current.language == .en ? "Likes: \($0)" :
            "Gustos: \($0)"
            return val
        }
        
        self.imageUrl = cellData
            .map { $0.recipe.image }
            .unwrap()
    }
    
    private var recipeTappedSubject = PublishSubject<Void>()
    var recipeTapped: AnyObserver<Void> {
        return recipeTappedSubject.asObserver()
    }
    
    private var favoriteButtonTappedSubject = PublishSubject<Void>()
    var favoriteButton: AnyObserver<Void> {
        favoriteButtonTappedSubject.asObserver()
    }
    
    private var recipeSubject = PublishSubject<Recipe>()
    func configureWith(recipe: Recipe) {
        recipeSubject.onNext(recipe)
    }
    
    var favoriteIcon: Observable<UIImage>
    var rating: Observable<StarRating>
    var title: Observable<String>
    var imageUrl: Observable<String>
    var price: Observable<String>
    var likes: Observable<String>
    
    var inputs: RecipesListCellViewModelInputs { return self }
    var outputs: RecipesListCellViewModelOutputs { return self }
}
