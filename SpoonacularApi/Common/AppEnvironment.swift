//
//  AppEnvironment.swift
//  SpoonacularApi
//
//  Created by Karthick Ramasamy on 4/19/20.
//  Copyright © 2020 Karthick Ramasamy. All rights reserved.
//

import Foundation

public struct AppEnvironment {
    
    /**
     A global stack of environments.
     */
    fileprivate static var stack: [Environment] = [Environment()]
    
    // The most recent environment on the stack.
    public static var current: Environment! {
      return stack.last
    }
    
    // Push a new environment onto the stack.
    public static func pushEnvironment(_ env: Environment) {
      self.stack.append(env)
    }
    
    // Pop an environment off the stack.
    @discardableResult
    public static func popEnvironment() -> Environment? {
      let last = self.stack.popLast()
      return last
    }
    
    static func pushEnvironment(
        apiService: ServiceType = AppEnvironment.current.apiService,
        spel: Spel = AppEnvironment.current.spel,
        bundle: Bundle = .main,
        recipeRecorder: FavoriteRecipeRecorderType = AppEnvironment.current.recipeRecorder,
        language: Language = AppEnvironment.current.language
    ) {
        self.pushEnvironment(
            Environment(
                apiService: apiService,
                spel: spel,
                bundle: bundle,
                recipeRecorder: recipeRecorder,
                language: language
            )
        )
    }
}
