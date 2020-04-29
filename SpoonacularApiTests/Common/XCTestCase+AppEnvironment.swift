//
//  XCTestCase+AppEnvironment.swift
//  SpoonacularApiTests
//
//  Created by Karthick Ramasamy on 4/19/20.
//  Copyright © 2020 Karthick Ramasamy. All rights reserved.
//

import Foundation
import XCTest
@testable import SpoonacularApi

extension XCTestCase {
    // Pushes an environment onto the stack, executes a closure, and then pops the environment from the stack.
    func withEnvironment(_ env: Environment, body: () -> Void) {
      AppEnvironment.pushEnvironment(env)
      body()
      AppEnvironment.popEnvironment()
    }
    
    func withEnvironment(
        apiService: ServiceType = AppEnvironment.current.apiService,
        spel: Spel = AppEnvironment.current.spel,
        bundle: Bundle = AppEnvironment.current.bundle,
        recipeRecorder: FavoriteRecipeRecorderType = AppEnvironment.current.recipeRecorder,
        language: Language = AppEnvironment.current.language,
        body: () -> Void) {
        self.withEnvironment(
            Environment(
                apiService: apiService,
                spel: spel,
                bundle: bundle,
                recipeRecorder: recipeRecorder,
                language: language
            ),
            body: body
        )
    }
}
