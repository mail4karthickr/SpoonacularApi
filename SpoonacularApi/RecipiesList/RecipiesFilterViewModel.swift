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

extension Observable {
    func withLatesFrom<T, U, R>(other1: Observable<T>, other2: Observable<U>, selector: @escaping (Element, T, U) -> R) -> Observable<R> {
        return self.withLatestFrom(Observable<Any>.combineLatest(
            other1,
            other2
        )) { x, y in selector(x, y.0, y.1) }
    }
}

struct RecipeFilter {
    var vegetarian: Bool
    var vegan: Bool
    var glutenFree: Bool
    var dairyFree: Bool
    var veryHealthy: Bool
    var cheap: Bool
    var veryPopular: Bool
    var weightWatcherPoints: ClosedRange<Int>
    var likes: Int
    var spoonacularScore: Int
    var healthScore: Int
    var priceRange: ClosedRange<Float>
    
    static var `default`: RecipeFilter {
        return RecipeFilter(vegetarian: false, vegan: false, glutenFree: false, dairyFree: false, veryHealthy: false, cheap: false, veryPopular: false, weightWatcherPoints: 1 ... 200,
                            likes: 0, spoonacularScore: 0, healthScore: 0, priceRange: 1 ... 200)
    }
    
    var allFilters: [FilterType] {
        return [
            FilterType.vegetarian(self.vegetarian),
            FilterType.vegan(self.vegan),
            FilterType.glutenFree(self.glutenFree),
            FilterType.dairyFree(self.dairyFree),
            FilterType.veryHealthy(self.veryHealthy),
            FilterType.cheap(self.cheap),
            FilterType.veryPopular(self.veryPopular),
            FilterType.weightWatcherPoints(self.weightWatcherPoints),
            FilterType.likes(self.likes),
            FilterType.spoonacularScore(self.spoonacularScore),
            FilterType.healthScore(self.healthScore),
            FilterType.priceRange(self.priceRange),
        ]
    }
}

extension RecipeFilter: Equatable {}

protocol ViewState {
    var vegetarianRelay: BehaviorRelay<Bool> { get }
    var veganRelay: BehaviorRelay<Bool> { get }
    var glutenFreeRelay: BehaviorRelay<Bool> { get }
    var dairyFreeRelay: BehaviorRelay<Bool> { get }
    var veryHealthyRelay: BehaviorRelay<Bool> { get }
    var cheapRelay: BehaviorRelay<Bool> { get }
    var veryPopularRelay: BehaviorRelay<Bool> { get }
    var weightWatcherPointsRelay: BehaviorRelay<ClosedRange<Int>> { get }
    var likesRelay: BehaviorRelay<Int> { get }
    var spoonacularScoreRelay: BehaviorRelay<Int> { get }
    var healthScoreRelay: BehaviorRelay<Int> { get }
    var priceRangeRelay: BehaviorRelay<ClosedRange<Float>> { get }
    
    var filteredRecipes: Observable<[Recipie]> { get }
    var appliedFilters: Observable<RecipeFilter> { get }
    func applyFilter()
    func viewDidLoad()
}

class RecipesFilterViewModel: ViewState {
    private var disposeBag = DisposeBag()
    
    var vegetarianRelay = BehaviorRelay<Bool>(value: RecipeFilter.default.vegetarian)
    var veganRelay = BehaviorRelay<Bool>(value: RecipeFilter.default.vegan)
    var glutenFreeRelay = BehaviorRelay<Bool>(value: RecipeFilter.default.glutenFree)
    var dairyFreeRelay = BehaviorRelay<Bool>(value: RecipeFilter.default.dairyFree)
    var veryHealthyRelay = BehaviorRelay<Bool>(value: RecipeFilter.default.veryHealthy)
    var cheapRelay = BehaviorRelay<Bool>(value: RecipeFilter.default.cheap)
    var veryPopularRelay = BehaviorRelay<Bool>(value: RecipeFilter.default.veryPopular)
    var weightWatcherPointsRelay = BehaviorRelay<ClosedRange<Int>>(value: RecipeFilter.default.weightWatcherPoints)
    var likesRelay = BehaviorRelay<Int>(value: RecipeFilter.default.likes)
    var spoonacularScoreRelay = BehaviorRelay<Int>(value: RecipeFilter.default.spoonacularScore)
    var healthScoreRelay = BehaviorRelay<Int>(value: RecipeFilter.default.healthScore)
    var priceRangeRelay = BehaviorRelay<ClosedRange<Float>>(value: RecipeFilter.default.priceRange)
    var filteredRecipes: Observable<[Recipie]>
    var appliedFilters: Observable<RecipeFilter>
    
    private var applyFilterSubject = PublishSubject<Void>()
    func applyFilter() {
        applyFilterSubject.onNext(())
    }
    
    private var viewDidLoadSubject = PublishSubject<Void>()
    func viewDidLoad() {
        viewDidLoadSubject.onNext(())
    }
    
    init(recipeResponse: RecipiesResponse, appliedFilter: RecipeFilter? = nil) {
    
        let lastSessionFilters = viewDidLoadSubject.withLatestFrom(Observable.just(appliedFilter)) { (_, filters) in return filters }.unwrap()

       lastSessionFilters.map { $0.vegetarian }.bind(to: vegetarianRelay).disposed(by: disposeBag)
       lastSessionFilters.map { $0.vegan }.bind(to: veganRelay).disposed(by: disposeBag)
       lastSessionFilters.map { $0.glutenFree }.bind(to: glutenFreeRelay).disposed(by: disposeBag)
       lastSessionFilters.map { $0.dairyFree }.bind(to: dairyFreeRelay).disposed(by: disposeBag)
       lastSessionFilters.map { $0.veryHealthy }.bind(to: veryHealthyRelay).disposed(by: disposeBag)
       lastSessionFilters.map { $0.cheap }.bind(to: cheapRelay).disposed(by: disposeBag)
       lastSessionFilters.map { $0.veryPopular }.bind(to: veryPopularRelay).disposed(by: disposeBag)
       lastSessionFilters.map { $0.weightWatcherPoints }.bind(to: weightWatcherPointsRelay).disposed(by: disposeBag)
       lastSessionFilters.map { $0.likes }.bind(to: likesRelay).disposed(by: disposeBag)
       lastSessionFilters.map { $0.spoonacularScore }.bind(to: spoonacularScoreRelay).disposed(by: disposeBag)
       lastSessionFilters.map { $0.healthScore }.bind(to: healthScoreRelay).disposed(by: disposeBag)
       lastSessionFilters.map { $0.priceRange }.bind(to: priceRangeRelay).disposed(by: disposeBag)
        
        let a = Observable.combineLatest(
            vegetarianRelay.map { $0 },
            veganRelay.map { $0 },
            glutenFreeRelay.map { $0 },
            dairyFreeRelay.map { $0 },
            veryHealthyRelay.map { $0 },
            cheapRelay.map { $0 },
            veryPopularRelay.map { $0 })
            .map { (isVegetarian: $0.0, isVegan: $0.1, isGlutenFree: $0.2, isDairyFree: $0.3, isVeryHealthy: $0.4, isCheap: $0.5, isVeryPopular: $0.6) }
        
        let b = Observable.combineLatest(
            weightWatcherPointsRelay.map { $0 },
            likesRelay.map { $0 },
            spoonacularScoreRelay.map { $0 },
            healthScoreRelay.map { $0 },
            priceRangeRelay.map { $0 })
            .map { (weightWatcherspoints: $0.0, noOfLikes: $0.1, spoonacularScore: $0.2, healthScore: $0.3, priceRange: $0.4) }
  
        let recipeFilter = Observable.combineLatest(a, b).map { (a, b) in
            RecipeFilter(vegetarian: a.isVegetarian, vegan: a.isVegan,
                         glutenFree: a.isGlutenFree, dairyFree: a.isDairyFree,
                         veryHealthy: a.isVeryHealthy, cheap: a.isCheap,
                         veryPopular: a.isVeryPopular, weightWatcherPoints: b.weightWatcherspoints,
                         likes: b.noOfLikes, spoonacularScore: b.spoonacularScore,
                         healthScore: b.healthScore, priceRange: b.priceRange)
        }

        let result = applyFilterSubject.withLatesFrom(other1: recipeFilter, other2: .just(recipeResponse)) { (element, recipeFilter, recipeResponse) in
            return (recipes: recipeResponse.filterRecipies(byFilters: recipeFilter.allFilters), filters: recipeFilter)
        }

        self.filteredRecipes = result.map { $0.recipes }
        
        self.appliedFilters = result.map { $0.filters }
    }
}
