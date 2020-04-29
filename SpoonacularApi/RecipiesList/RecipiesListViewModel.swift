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

enum FilterType {
    case vegetarian(Bool)
    case vegan(Bool)
    case glutenFree(Bool)
    case dairyFree(Bool)
    case veryHealthy(Bool)
    case cheap(Bool)
    case veryPopular(Bool)
    case weightWatcherPoints(ClosedRange<Int>)
    case likes(Int)
    case spoonacularScore(Int)
    case healthScore(Int)
    case priceRange(ClosedRange<Float>)
}

protocol RecipiesListViewModelInputs {
    func retry()
    func viewDidLoad()
    func removeFilters()
    func filterRecipies(byFilterType filter: FilterType)
}

protocol RecipiesListViewModelOutputs {
    var shouldShowActivityIndicator: Driver<Bool> { get }
    var getRecipiesFailure: Driver<String> { get }
    var recipies: Driver<[Recipie]> { get }
    var noRecipiesFound: Driver<String> { get }
}

protocol RecipiesViewModelType {
    var inputs: RecipiesListViewModelInputs { get }
    var outputs: RecipiesListViewModelOutputs { get }
}

class RecipiesListViewModel: RecipiesViewModelType, RecipiesListViewModelInputs, RecipiesListViewModelOutputs {

    init(apiService: ServiceType) {
        let fetchRecipies = Observable.merge(viewDidLoadSubject, retrySubject)
        
        let getRecipiesEvent = fetchRecipies
            .flatMapLatest { apiService.getRandomRecipies().materialize() }
        
        let getRecipiesResponse = getRecipiesEvent
            .map { $0.element }
            .unwrap()
        
        let recipies = getRecipiesResponse
            .map { $0.recipes }
        
        let apiError = getRecipiesEvent
            .map { $0.error }
            .ofType(ApiError.self)
            .map { $0.localizedMessage }
        
        self.getRecipiesFailure = Observable.merge(apiError)
            .asDriver(onErrorJustReturn: ApiError.decodingFailed.localizedMessage)

        let filteredRecipies = filterRecipiesSubject
            .withLatestFrom(getRecipiesResponse) { (filterType: $0, recipiesResponse: $1) }
            .map { $0.recipiesResponse.filterRecipies(byFilterType: $0.filterType) }
        
        let allRecipies = removeFiltersSubject.withLatestFrom(getRecipiesResponse)
            .map { $0.recipes }
        
        self.recipies = Observable.merge(recipies, filteredRecipies, allRecipies)
            .asDriver(onErrorJustReturn: [])
        
        self.noRecipiesFound = self.recipies
            .filter { $0.isEmpty }
            .map { _ in "No Recipes Found" }

        shouldShowActivityIndicator = Observable.merge(
            fetchRecipies.map { _ in true },
            getRecipiesResponse.asObservable().map { _ in false },
            self.getRecipiesFailure.asObservable().map { _ in false })
            .asDriver(onErrorJustReturn: false)
    }
    
    var inputs: RecipiesListViewModelInputs {
        return self
    }
    
    var outputs: RecipiesListViewModelOutputs {
        return self
    }
    
    private var viewDidLoadSubject = ReplaySubject<Void>.create(bufferSize: 1)
    func viewDidLoad() {
        viewDidLoadSubject.onNext(())
    }
    
    private var filterRecipiesSubject = PublishSubject<FilterType>()
    func filterRecipies(byFilterType filter: FilterType) {
        filterRecipiesSubject.onNext(filter)
    }
    
    private var retrySubject = ReplaySubject<Void>.create(bufferSize: 1)
    func retry() {
        retrySubject.onNext(())
    }
    
    private var removeFiltersSubject = ReplaySubject<Void>.create(bufferSize: 1)
    func removeFilters() {
        removeFiltersSubject.onNext(())
    }
    
  //  var noRecipiesFoundError: Driver<Bool>
    var shouldShowActivityIndicator: Driver<Bool>
    var getRecipiesFailure: Driver<String>
    var recipies: Driver<[Recipie]>
    var noRecipiesFound: Driver<String>
}
