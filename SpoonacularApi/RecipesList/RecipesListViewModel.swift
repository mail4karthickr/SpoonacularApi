//
//  RecipiesListViewModel.swift
//  SpoonacularApi
//
//  Created by Karthick Ramasamy on 3/30/20.
//  Copyright © 2020 Karthick Ramasamy. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxSwiftExt

protocol RecipesListViewModelInputs {
    func retry()
    func viewDidLoad()
    var filteredRecipes: AnyObserver<[Recipe]> { get }
    var didSelectRecipeAtIndexPath: AnyObserver<IndexPath> { get }
    var markAsFavourite: AnyObserver<IndexPath> { get }
}

protocol RecipesListViewModelOutputs {
    var shouldShowActivityIndicator: Driver<Bool> { get }
    var getRecipiesFailure: Driver<String> { get }
    var noRecipesFound: Driver<String> { get }
    var recipeResponse: Driver<RecipeResponse> { get }
    var recipes: Driver<[Recipe]> { get }
}

protocol RecipesViewModelType {
    var inputs: RecipesListViewModelInputs { get }
    var outputs: RecipesListViewModelOutputs { get }
}

extension RecipeResponse {
    func toRecipeListCellData() -> [RecipeListCellData] {
        self.recipes.map { RecipeListCellData(recipe: $0) }
    }
}

class RecipesListViewModel: RecipesViewModelType, RecipesListViewModelInputs, RecipesListViewModelOutputs {
    
    init() {
        let fetchRecipies = Observable.merge(viewDidLoadSubject, retrySubject)
            .share()

        let getRecipiesEvent = fetchRecipies
            .flatMapLatest { AppEnvironment.current.apiService.getRandomRecipies().materialize() }
            .share()
        
        self.recipeResponse = getRecipiesEvent
            .map { $0.element }
            .unwrap()
            .share()
            .asDriver(onErrorJustReturn: RecipeResponse(recipes: []))
        
        let recipes = self.recipeResponse.map { $0.recipes }
        
        self.recipes = Observable.merge(recipes.asObservable(), filteredRecipesSubject)
        .asDriver(onErrorJustReturn: [])
        
        let apiError = getRecipiesEvent
            .map { $0.error }
            .do(onNext: { err in
                print(err)
            })
            .ofType(ApiError.self)
            .do(onNext: { err in
                print(err)
            })
            .map { $0.localizedMessage }
            .do(onNext: { err in
                print(err)
            })
        
        self.getRecipiesFailure = Observable.merge(apiError)
            .share()
            .asDriver(onErrorJustReturn: ApiError.decodingFailed.localizedMessage)
            
        self.noRecipesFound = self.recipeResponse
            .map { $0.recipes }
            .filter { $0.isEmpty }
            .map { _ in "No Recipes Found" }
            .asDriver(onErrorJustReturn: "Unknown error")

        shouldShowActivityIndicator = Observable.merge(
            fetchRecipies.map { _ in true },
            self.recipeResponse.asObservable().map { _ in false },
            self.getRecipiesFailure.asObservable().map { _ in false })
            .asDriver(onErrorJustReturn: false)
    }
    
    var inputs: RecipesListViewModelInputs {
        return self
    }
    
    var outputs: RecipesListViewModelOutputs {
        return self
    }
    
    private var viewDidLoadSubject = ReplaySubject<Void>.create(bufferSize: 1)
    func viewDidLoad() {
        viewDidLoadSubject.onNext(())
    }

    private var retrySubject = ReplaySubject<Void>.create(bufferSize: 1)
    func retry() {
        retrySubject.onNext(())
    }
    
    private var filteredRecipesSubject = PublishSubject<[Recipe]>()
    var filteredRecipes: AnyObserver<[Recipe]> {
        return filteredRecipesSubject.asObserver()
    }

    private var didSelectRowAtIPSubject = PublishSubject<IndexPath>()
    var didSelectRecipeAtIndexPath: AnyObserver<IndexPath> {
        return didSelectRowAtIPSubject.asObserver()
    }
    
    private var markAsFavouriteSubject = PublishSubject<IndexPath>()
    var markAsFavourite: AnyObserver<IndexPath> {
        return markAsFavouriteSubject.asObserver()
    }
    
    var shouldShowActivityIndicator: Driver<Bool>
    var getRecipiesFailure: Driver<String>
    var noRecipesFound: Driver<String>
    var recipeResponse: Driver<RecipeResponse>
    var recipes: Driver<[Recipe]>
}
