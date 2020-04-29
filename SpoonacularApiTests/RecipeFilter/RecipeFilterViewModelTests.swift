//
//  RecipesFilterViewModelTests.swift
//  SpoonacularApiTests
//
//  Created by Karthick Ramasamy on 4/8/20.
//  Copyright © 2020 Karthick Ramasamy. All rights reserved.
//

import Foundation
import XCTest
import RxTest
import RxSwift
import RxCocoa

@testable import SpoonacularApi

class RecipesFilterViewModelTests: TestCase {
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
    var mockService: MockService!
    var appliedFilter: RecipeFilter!
    var vegetarianObserver: TestableObserver<Bool>!
    var veganObserver: TestableObserver<Bool>!
    var glutenFreeObserver: TestableObserver<Bool>!
    var dairyFreeObserver: TestableObserver<Bool>!
    var veryHealthyObserver: TestableObserver<Bool>!
    var cheapObserver: TestableObserver<Bool>!
    var veryPopularObserver: TestableObserver<Bool>!
    var vm: RecipesFilterViewModel!
    var filteredRecipesObserver: TestableObserver<[Recipe]>!
    var appliedFiltersObserver: TestableObserver<RecipeFilter>!
    var clearAllButtonStateObserver: TestableObserver<Bool>!
    
    override func setUp() {
        super.setUp()
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
        mockService = MockService()
        appliedFilter = nil
        
        SharingScheduler.mock(scheduler: scheduler) {
            vm = RecipesFilterViewModel()
            
            vegetarianObserver = scheduler.createObserver(Bool.self)
            veganObserver = scheduler.createObserver(Bool.self)
            glutenFreeObserver = scheduler.createObserver(Bool.self)
            dairyFreeObserver = scheduler.createObserver(Bool.self)
            veryHealthyObserver = scheduler.createObserver(Bool.self)
            veryHealthyObserver = scheduler.createObserver(Bool.self)
            cheapObserver = scheduler.createObserver(Bool.self)
            veryPopularObserver = scheduler.createObserver(Bool.self)
            filteredRecipesObserver = scheduler.createObserver([Recipe].self)
            appliedFiltersObserver = scheduler.createObserver(RecipeFilter.self)
            clearAllButtonStateObserver = scheduler.createObserver(Bool.self)
            
            vm.vegetarianRelay.bind(to: vegetarianObserver).disposed(by: disposeBag)
            vm.veganRelay.bind(to: veganObserver).disposed(by: disposeBag)
            vm.glutenFreeRelay.bind(to: glutenFreeObserver).disposed(by: disposeBag)
            vm.dairyFreeRelay.bind(to: dairyFreeObserver).disposed(by: disposeBag)
            vm.veryHealthyRelay.bind(to: veryHealthyObserver).disposed(by: disposeBag)
            vm.cheapRelay.bind(to: cheapObserver).disposed(by: disposeBag)
            vm.veryPopularRelay.bind(to: veryPopularObserver).disposed(by: disposeBag)
            vm.filteredRecipes.drive(filteredRecipesObserver).disposed(by: disposeBag)
            vm.appliedFilters.drive(appliedFiltersObserver).disposed(by: disposeBag)
            vm.clearAllButtonRelay.bind(to: clearAllButtonStateObserver).disposed(by: disposeBag)
        }
    }
    
    func testFilterValues_onViewDidLoad_whenLastSessionFilterIsNil() {
        scheduler.scheduleAt(0) {
            self.vm.configureWith(recipeResponse: MockService.getRandomRecipiesResponse(), recipeFilter: nil)
            self.vm.viewDidLoad()
        }
        scheduler.start()
        
        XCTAssertEqual([.next(0, false)], vegetarianObserver.events)
        XCTAssertEqual([.next(0, false)], veganObserver.events)
        XCTAssertEqual([.next(0, false)], glutenFreeObserver.events)
        XCTAssertEqual([.next(0, false)], dairyFreeObserver.events)
        XCTAssertEqual([.next(0, false)], veryHealthyObserver.events)
        XCTAssertEqual([.next(0, false)], cheapObserver.events)
        XCTAssertEqual([.next(0, false)], veryPopularObserver.events)
        XCTAssertEqual([.next(0, false)], veryPopularObserver.events)
    }
    
    func testFilterValues_onViewDidLoad_whenLastSessionFilterIsNotNil() {
        scheduler.scheduleAt(0) {
            let recipeFilter = RecipeFilter(vegetarian: true,
                                            vegan: false,
                                            glutenFree: true,
                                            dairyFree: false,
                                            veryHealthy: true,
                                            cheap: false,
                                            veryPopular: true)
            self.vm.configureWith(recipeResponse: MockService.getRandomRecipiesResponse(), recipeFilter: recipeFilter)
            self.vm.viewDidLoad()
        }
        scheduler.start()
        
        XCTAssertEqual([.next(0, false), .next(0, true)], vegetarianObserver.events)
        XCTAssertEqual([.next(0, false), .next(0, false)], veganObserver.events)
        XCTAssertEqual([.next(0, false), .next(0, true)], glutenFreeObserver.events)
        XCTAssertEqual([.next(0, false), .next(0, false)], dairyFreeObserver.events)
        XCTAssertEqual([.next(0, false), .next(0, true)], veryHealthyObserver.events)
        XCTAssertEqual([.next(0, false), .next(0, false)], cheapObserver.events)
        XCTAssertEqual([.next(0, false), .next(0, true)], veryPopularObserver.events)
    }
    
    func testClearAllButtonState_onViewDidLoad_whenLastSessionFilterIsNil() {
        scheduler.scheduleAt(0) {
            self.vm.configureWith(recipeResponse: MockService.getRandomRecipiesResponse(), recipeFilter: nil)
            self.vm.viewDidLoad()
        }
        scheduler.start()
        
        XCTAssertEqual([.next(0, false)], clearAllButtonStateObserver.events)
    }
    
    func testClearAllButtonState_onViewDidLoad_whenLastSessionFilterIsNotNil() {
        scheduler.scheduleAt(0) {
            let recipeFilter = RecipeFilter(vegetarian: true,
                                            vegan: false,
                                            glutenFree: true,
                                            dairyFree: false,
                                            veryHealthy: true,
                                            cheap: false,
                                            veryPopular: true)
            self.vm.configureWith(recipeResponse: MockService.getRandomRecipiesResponse(), recipeFilter: recipeFilter)
            self.vm.viewDidLoad()
        }
        scheduler.start()
        
        XCTAssertEqual([.next(0, false), .next(0, true)], clearAllButtonStateObserver.events)
    }
    
    func testClearAllButtonStateWhenFilterSwitchIsToggled() {
        scheduler.scheduleAt(0) {
            self.vm.configureWith(recipeResponse: MockService.getRandomRecipiesResponse(), recipeFilter: nil)
            self.vm.viewDidLoad()
        }
        
        scheduler.scheduleAt(1) {
            self.vm.vegetarianRelay.accept(true)
        }
        
        scheduler.scheduleAt(2) {
            self.vm.vegetarianRelay.accept(false)
        }
        
        scheduler.start()
        
        XCTAssertEqual([.next(0, false),
                        .next(1, true),
                        .next(2, false)], clearAllButtonStateObserver.events)
    }
    
    func testClearAllButtonAction() {
        scheduler.scheduleAt(0) {
            let recipeFilter = RecipeFilter(vegetarian: true,
                                            vegan: false,
                                            glutenFree: true,
                                            dairyFree: false,
                                            veryHealthy: true,
                                            cheap: false,
                                            veryPopular: true)
            self.vm.configureWith(recipeResponse: MockService.getRandomRecipiesResponse(), recipeFilter: recipeFilter)
            self.vm.viewDidLoad()
        }
        
        scheduler.scheduleAt(1) {
            self.vm.resetFilter()
        }
        
        scheduler.start()
        
       XCTAssertEqual([.next(0, false), .next(0, true), .next(1, false)], vegetarianObserver.events)
       XCTAssertEqual([.next(0, false), .next(0, false), .next(1, false)], veganObserver.events)
       XCTAssertEqual([.next(0, false), .next(0, true), .next(1, false)], glutenFreeObserver.events)
       XCTAssertEqual([.next(0, false), .next(0, false), .next(1, false)], dairyFreeObserver.events)
       XCTAssertEqual([.next(0, false), .next(0, true), .next(1, false)], veryHealthyObserver.events)
       XCTAssertEqual([.next(0, false), .next(0, false), .next(1, false)], cheapObserver.events)
       XCTAssertEqual([.next(0, false), .next(0, true), .next(1, false)], veryPopularObserver.events)
    }
    
    func testApplyFilter() {
        withEnvironment(apiService: MockService()) {
            scheduler.scheduleAt(0) {
                self.vm.configureWith(recipeResponse: MockService.getRandomRecipiesResponse(), recipeFilter: nil)
                self.vm.viewDidLoad()
            }
            scheduler.scheduleAt(1) {
                self.vm.dairyFreeRelay.accept(true)
                self.vm.applyFilter()
            }
            scheduler.scheduleAt(2) {
                self.vm.dairyFreeRelay.accept(false)
                self.vm.vegetarianRelay.accept(true)
                self.vm.applyFilter()
            }
            scheduler.scheduleAt(3) {
                self.vm.resetFilter()
                self.vm.applyFilter()
            }
            
            scheduler.start()
            
            var dairyFreeRecipeFilter = RecipeFilter.default
            dairyFreeRecipeFilter.dairyFree = true
            var vegetarianRecipeFilter = RecipeFilter.default
            vegetarianRecipeFilter.vegetarian = true
            
            let expectedFilteredRecipes: [Recorded<Event<RecipeFilter>>] = [
                .next(2, dairyFreeRecipeFilter),
                .next(3, vegetarianRecipeFilter),
                .next(4, RecipeFilter.default)
            ]
            
            XCTAssertEqual(expectedFilteredRecipes, appliedFiltersObserver.events)
            XCTAssertEqual([
                .next(2, MockService.getDairyFreeRecipieResponse().recipes),
                .next(3, MockService.getVegetarianRecipieResponse().recipes),
                .next(4, MockService.getRandomRecipiesResponse().recipes)
            ], filteredRecipesObserver.events)
        }
    }
}
