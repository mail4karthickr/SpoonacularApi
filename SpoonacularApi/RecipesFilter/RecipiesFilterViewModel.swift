//
//  RecipiesFilterViewModel.swift
//  SpoonacularApi
//
//  Created by Karthick Ramasamy on 4/6/20.
//  Copyright © 2020 Karthick Ramasamy. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol ViewState {
    var vegetarianRelay: BehaviorRelay<Bool> { get }
    var veganRelay: BehaviorRelay<Bool> { get }
    var glutenFreeRelay: BehaviorRelay<Bool> { get }
    var dairyFreeRelay: BehaviorRelay<Bool> { get }
    var veryHealthyRelay: BehaviorRelay<Bool> { get }
    var cheapRelay: BehaviorRelay<Bool> { get }
    var veryPopularRelay: BehaviorRelay<Bool> { get }
    
    var filteredRecipes: Driver<[Recipe]> { get }
    var appliedFilters: Driver<RecipeFilter>  { get }
    var clearAllButtonRelay: BehaviorRelay<Bool> { get }
    
    func applyFilter()
    func viewDidLoad()
    func resetFilter()
    func configureWith(recipeResponse: RecipeResponse, recipeFilter: RecipeFilter?)
}

class RecipesFilterViewModel: ViewState {
    private var disposeBag = DisposeBag()
    
    var vegetarianRelay = BehaviorRelay<Bool>(value: RecipeFilter.default.vegetarian)
    var veganRelay = BehaviorRelay<Bool>(value: RecipeFilter.default.vegan)
    var glutenFreeRelay = BehaviorRelay<Bool>(value: RecipeFilter.default.glutenFree)
    var dairyFreeRelay = BehaviorRelay<Bool>(value: false)
    var veryHealthyRelay = BehaviorRelay<Bool>(value: RecipeFilter.default.veryHealthy)
    var cheapRelay = BehaviorRelay<Bool>(value: RecipeFilter.default.cheap)
    var veryPopularRelay = BehaviorRelay<Bool>(value: RecipeFilter.default.veryPopular)
    
    var filteredRecipes: Driver<[Recipe]>
    var appliedFilters: Driver<RecipeFilter>
    var clearAllButtonRelay = BehaviorRelay<Bool>(value: false)
    
    private var applyFilterSubject = PublishSubject<Void>()
    func applyFilter() {
        AppEnvironment.current.spel.appliedRecipeFilter()
        applyFilterSubject.onNext(())
    }
    
    private var viewDidLoadSubject = PublishSubject<Void>()
    func viewDidLoad() {
        AppEnvironment.current.spel.launchedRecipeFilterPage()
        viewDidLoadSubject.onNext(())
    }
    
    private var resetFilterSubject = PublishSubject<Void>()
    func resetFilter() {
        resetFilterSubject.onNext(())
    }
    
    private var recipeResponseSubject = ReplaySubject<(recipeResponse: RecipeResponse, recipeFilter: RecipeFilter?)>.create(bufferSize: 1)
    func configureWith(recipeResponse: RecipeResponse, recipeFilter: RecipeFilter?) {
        recipeResponseSubject.onNext((recipeResponse, recipeFilter))
    }
    
    init() {
        let recipeResponse = recipeResponseSubject.map { $0.recipeResponse }
        let lastSessionFilter = recipeResponseSubject.map { $0.recipeFilter }
        
        let lastSessionFilters =  viewDidLoadSubject.withLatestFrom(lastSessionFilter) { (_, filters) in return filters }
            .unwrap()
            .share()

        let defaultFilter = Observable.just(RecipeFilter.default)
        
        let filter = Observable.merge(lastSessionFilters, defaultFilter, resetFilterSubject.map { RecipeFilter.default })
        
        filter.map { $0.vegetarian }.bind(to: vegetarianRelay).disposed(by: disposeBag)
        filter.map { $0.vegan }.bind(to: veganRelay).disposed(by: disposeBag)
        filter.map { $0.glutenFree }.bind(to: glutenFreeRelay).disposed(by: disposeBag)
        filter.map { $0.dairyFree }.bind(to: dairyFreeRelay).disposed(by: disposeBag)
        filter.map { $0.veryHealthy }.bind(to: veryHealthyRelay).disposed(by: disposeBag)
        filter.map { $0.cheap }.bind(to: cheapRelay).disposed(by: disposeBag)
        filter.map { $0.veryPopular }.bind(to: veryPopularRelay).disposed(by: disposeBag)
        
        let recipeFilter = Observable.combineLatest(
            vegetarianRelay.map { $0 }.do(onNext: { AppEnvironment.current.spel.toggledFilter(type: .vegetarian, value: $0) }),
            veganRelay.map { $0 }.do(onNext: { AppEnvironment.current.spel.toggledFilter(type: .vegan, value: $0) }),
            glutenFreeRelay.map { $0 }.do(onNext: { AppEnvironment.current.spel.toggledFilter(type: .glutenFree, value: $0) }),
            dairyFreeRelay.map { $0 }.do(onNext: { AppEnvironment.current.spel.toggledFilter(type: .dairyFree, value: $0) }),
            veryHealthyRelay.map { $0 }.do(onNext: { AppEnvironment.current.spel.toggledFilter(type: .veryHealthy, value: $0) }),
            cheapRelay.map { $0 }.do(onNext: { AppEnvironment.current.spel.toggledFilter(type: .cheap, value: $0) }),
            veryPopularRelay.map { $0 }.do(onNext: { AppEnvironment.current.spel.toggledFilter(type: .veryPopular, value: $0) }))
            .map {
                RecipeFilter(vegetarian: $0.0, vegan: $0.1, glutenFree: $0.2, dairyFree: $0.3, veryHealthy: $0.4, cheap: $0.5, veryPopular: $0.6)
            }

        recipeFilter.map { $0.activeFilters.count > 0 }
            .distinctUntilChanged()
            .bind(to: clearAllButtonRelay).disposed(by: disposeBag)
        
        let responseAndFilter = Observable.combineLatest(recipeResponse, recipeFilter)
        
        let result = applyFilterSubject.withLatestFrom(responseAndFilter) {
            (recipes: $1.0.filterRecipies(byFilters: $1.1.activeFilters),
              recipeFilter: $1.1)
        }
        
        self.filteredRecipes = result.map { $0.recipes }
            .asDriver(onErrorJustReturn: [])

        self.appliedFilters = result.map { $0.recipeFilter }
            .asDriver(onErrorJustReturn: RecipeFilter.default)
    }
}
