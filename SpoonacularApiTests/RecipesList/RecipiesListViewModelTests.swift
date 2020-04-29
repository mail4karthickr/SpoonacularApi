//
//  RecipiesListViewModelTests.swift
//  SpoonacularApiTests
//
//  Created by Karthick Ramasamy on 4/1/20.
//  Copyright © 2020 Karthick Ramasamy. All rights reserved.
//

import Foundation
import XCTest
import RxTest
import RxSwift
import RxCocoa

@testable import SpoonacularApi

class RecipiesListViewModelTests: TestCase {
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
    var mockService: MockService!
    var errorObserver: TestableObserver<String>!
    var showLoaderObserver: TestableObserver<Bool>!
    var recipesObserver: TestableObserver<[Recipe]>!
    var navigateToRecipeDetailObserver: TestableObserver<Recipe>!
    var noRecipesObserver: TestableObserver<String>!
    var vm: RecipesListViewModel!
    
    override func setUp() {
        super.setUp()
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
        mockService = MockService()
        SharingScheduler.mock(scheduler: scheduler) {
            vm = RecipesListViewModel()
            
            errorObserver = scheduler.createObserver(String.self)
            showLoaderObserver = scheduler.createObserver(Bool.self)
            recipesObserver = scheduler.createObserver([Recipe].self)
            navigateToRecipeDetailObserver = scheduler.createObserver(Recipe.self)
            noRecipesObserver = scheduler.createObserver(String.self)
            
            vm.outputs.recipes.drive(recipesObserver).disposed(by: disposeBag)
            vm.outputs.shouldShowActivityIndicator.drive(showLoaderObserver).disposed(by: disposeBag)
            vm.outputs.getRecipiesFailure.drive(errorObserver).disposed(by: disposeBag)
            vm.outputs.noRecipesFound.drive(noRecipesObserver).disposed(by: disposeBag)
        }
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testGetRecipes() {
        let expectedShowLoader: [Recorded<Event<Bool>>] = [
            .next(1, true),
            .next(2, false)
        ]
        
        let expectedRecipies: [Recorded<Event<[Recipe]>>] = [
            .next(2, MockService.getRandomRecipiesResponse().recipes)
        ]
        
        withEnvironment(apiService: MockService()) {
            scheduler.createHotObservable([.next(0, ())]).subscribe(onNext: {
                self.vm.inputs.viewDidLoad()
            })
            .disposed(by: disposeBag)

            self.scheduler.start()
            
            XCTAssertEqual(expectedShowLoader, showLoaderObserver.events)
            XCTAssertEqual(expectedRecipies, recipesObserver.events)
            XCTAssertEqual([], errorObserver.events)
        }
    }
    
    func testGetRecipiesFailure() {
        let expectedShowLoader: [Recorded<Event<Bool>>] = [
            .next(1, true),
            .next(2, false)
        ]
        
        let expectedError: [Recorded<Event<String>>] = [
            .next(1, ApiError.decodingFailed.localizedMessage)
        ]
        
        withEnvironment(apiService: MockService(randomRecipiesError: .decodingFailed)) {
            scheduler.scheduleAt(0) { self.vm.inputs.viewDidLoad() }

            self.scheduler.start()
            
            XCTAssertEqual(expectedShowLoader, showLoaderObserver.events)
            XCTAssertEqual([], recipesObserver.events)
            XCTAssertEqual(expectedError, errorObserver.events)
        }
    }
    
    func testGetRecipesRetry_Success() {
        let expectedShowLoader: [Recorded<Event<Bool>>] = [
            .next(1, true),
            .next(2, false),
            .next(4, true),
            .next(5, false)
        ]
        
        let expectedError: [Recorded<Event<String>>] = [
            .next(1, ApiError.decodingFailed.localizedMessage)
        ]
        
        let expectedRecipies: [Recorded<Event<[Recipe]>>] = [
            .next(5, MockService.getRandomRecipiesResponse().recipes),
        ]
    
        scheduler.scheduleAt(0) {
            self.withEnvironment(apiService: MockService(randomRecipiesError: .decodingFailed)) {
                self.vm.inputs.viewDidLoad()
            }
        }
        
        scheduler.scheduleAt(3) {
            self.withEnvironment(apiService: MockService()) {
                self.vm.inputs.retry()
            }
        }

        self.scheduler.start()
        
        XCTAssertEqual(expectedShowLoader, showLoaderObserver.events)
        XCTAssertEqual(expectedRecipies, recipesObserver.events)
        XCTAssertEqual(expectedError, errorObserver.events)
    }
    
    func testGetRecipesRetry_Failure() {
       let expectedShowLoader: [Recorded<Event<Bool>>] = [
           .next(1, true),
           .next(2, false),
           .next(4, true),
           .next(5, false)
       ]
       
       let expectedError: [Recorded<Event<String>>] = [
           .next(1, ApiError.decodingFailed.localizedMessage),
           .next(4, ApiError.networkNotAvailable.localizedMessage)
       ]

       scheduler.scheduleAt(0) {
           self.withEnvironment(apiService: MockService(randomRecipiesError: .decodingFailed)) {
               self.vm.inputs.viewDidLoad()
           }
       }
       
       scheduler.scheduleAt(3) {
            self.withEnvironment(apiService: MockService(randomRecipiesError: .networkNotAvailable)) {
                self.vm.inputs.retry()
            }
       }

       self.scheduler.start()
       
       XCTAssertEqual(expectedShowLoader, showLoaderObserver.events)
       XCTAssertEqual([], recipesObserver.events)
       XCTAssertEqual(expectedError, errorObserver.events)
    }
    
    // Disable this test for now
    func disabletestRecipeDetailNavigation() {
        let expectedShowLoader: [Recorded<Event<Bool>>] = [
            .next(1, true),
            .next(2, false),
        ]
        
        let expectedRecipes: [Recorded<Event<[Recipe]>>] = [
            .next(2, MockService.getRandomRecipiesResponse().recipes)
        ]
        let ip = IndexPath(row: 0, section: 0)
        let expectedSelectedRecipe: [Recorded<Event<Recipe>>] = [
            .next(3, MockService.getRandomRecipiesResponse().recipes[ip.row])
        ]
        
        self.withEnvironment(apiService: MockService()) {
            scheduler.scheduleAt(0) {
                self.vm.inputs.viewDidLoad()
            }
            
            scheduler.createHotObservable([.next(3, ip)])
                .bind(to: self.vm.inputs.didSelectRecipeAtIndexPath)
                .disposed(by: disposeBag)

            scheduler.start()
            
            XCTAssertEqual(expectedSelectedRecipe, navigateToRecipeDetailObserver.events)
            XCTAssertEqual(expectedShowLoader, showLoaderObserver.events)
            XCTAssertEqual(expectedRecipes, recipesObserver.events)
            XCTAssertEqual([], errorObserver.events)
        }
    }
    
    func testNoRecipesFoundError() {
        let expectedShowLoader: [Recorded<Event<Bool>>] = [
            .next(1, true),
            .next(2, false),
        ]
        
        let expectedError: [Recorded<Event<String>>] = [
            .next(2, "No Recipes Found"),
        ]
        
        let expectedRecipes: [Recorded<Event<[Recipe]>>] = [
            .next(2, [])
        ]
        
        self.withEnvironment(apiService: MockService(randomRecipiesResponse: RecipeResponse(recipes: []))) {
            scheduler.scheduleAt(0) {
                self.vm.inputs.viewDidLoad()
            }
            
            scheduler.start()
            
            XCTAssertEqual(expectedShowLoader, showLoaderObserver.events)
            XCTAssertEqual(expectedError, noRecipesObserver.events)
            XCTAssertEqual(expectedRecipes, recipesObserver.events)
            XCTAssertEqual([], errorObserver.events)
        }
    }
    
    func testFilteredRecipes() {
        let expectedShowLoader: [Recorded<Event<Bool>>] = [
            .next(1, true),
            .next(2, false),
        ]
        
        let expectedRecipes: [Recorded<Event<[Recipe]>>] = [
            .next(2, MockService.getRandomRecipiesResponse().recipes),
            .next(4, MockService.getDairyFreeRecipieResponse().recipes)
        ]
        
        self.withEnvironment(apiService: MockService()) {
            scheduler.scheduleAt(0) {
                self.vm.inputs.viewDidLoad()
            }
            
            scheduler.createHotObservable([.next(3, MockService.getDairyFreeRecipieResponse().recipes)])
                .bind(to: self.vm.inputs.filteredRecipes)
                .disposed(by: disposeBag)
            
            scheduler.start()
            
            XCTAssertEqual(expectedShowLoader, showLoaderObserver.events)
            XCTAssertEqual(expectedRecipes, recipesObserver.events)
        }
    }
}
