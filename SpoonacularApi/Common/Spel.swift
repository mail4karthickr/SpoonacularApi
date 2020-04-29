//
//  SEL.swift
//  SpoonacularApi
//
//  Created by Karthick Ramasamy on 4/22/20.
//  Copyright © 2020 Karthick Ramasamy. All rights reserved.
//

import Foundation

enum RecipeFilterLogs: LogNameType {
    var logName: String {
        switch self {
        case .launched:
            return "Launched"
        case .clearAllButtonTapped:
            return "ClearAllButtonTapped"
        case .applyFilter:
            return "ApplyFilter"
        case .toggleFilter(let type):
            return "ToggleFilter type \(type.rawValue)"
        }
    }
    
    case launched
    case clearAllButtonTapped
    case toggleFilter(_ type: FilterType)
    case applyFilter
}

/// Spoonacular event logger
class Spel {
    let client: TrackingClientType
    var recipeFilterUseCase: UseCase?
    
    init(client: TrackingClientType) {
        self.client = client
    }
    
    func startRecipeFilterUseCase() {
//        self.recipeFilterUseCase = UseCase(type: .filterRecipe, id: UUID().uuidString)
//        client.track(self.recipeFilterUseCase!)
    }
    
    func launchedRecipeFilterPage() {
//          guard let useCase = self.recipeFilterUseCase else {
//                      fatalError("launchedRecipeFilterPage must be called")
//                  }
//        let logInfo = LogInfo(useCase: useCase, loglevel: .info, logNameType: RecipeFilterLogs.launched, userInfo: ["message": "launchedRecipeFilterPage"])
//            client.track(logInfo)
        }
        
        func toggledFilter(type: FilterType, value: Bool) {
//            guard let useCase = self.recipeFilterUseCase else {
//                fatalError("launchedRecipeFilterPage must be called")
//            }
//            let logInfo = LogInfo(useCase: useCase, loglevel: .info, logNameType: RecipeFilterLogs.toggleFilter(type), userInfo: ["filterType": type.rawValue, "value": value ? "True": "False"])
          //  client.track(logInfo)
        }
        
        func clearAllButtonTapped() {
//            guard let useCase = self.recipeFilterUseCase else {
//                fatalError("launchedRecipeFilterPage must be called")
//            }
//            let logInfo = LogInfo(useCase: useCase, loglevel: .info, logNameType: RecipeFilterLogs.clearAllButtonTapped, userInfo: ["message": "clearallbuttontapped"])
//            client.track(logInfo)
        }
        
        func appliedRecipeFilter() {
//            guard let useCase = self.recipeFilterUseCase else {
//                fatalError("launchedRecipeFilterPage must be called")
//            }
//            let logInfo = LogInfo(useCase: useCase, loglevel: .info, logNameType: RecipeFilterLogs.applyFilter, userInfo: ["message": "appliedrecipeFilter"])
//            client.track(logInfo)
        }
    }
