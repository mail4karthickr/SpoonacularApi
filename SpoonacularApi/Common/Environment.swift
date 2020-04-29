//
//  Environment.swift
//  SpoonacularApi
//
//  Created by Karthick Ramasamy on 4/19/20.
//  Copyright © 2020 Karthick Ramasamy. All rights reserved.
//

import Foundation

public struct Environment {
    let apiService: ServiceType
    let spel: Spel
    let bundle: Bundle
    let recipeRecorder: FavoriteRecipeRecorderType
    let language: Language
    
    init(apiService: ServiceType = Service(),
         spel: Spel = Spel(client: TrackingClient()),
         bundle: Bundle = .main,
         recipeRecorder: FavoriteRecipeRecorderType = FavoriteRecipeRecorder(),
         language: Language = .en) {
        self.apiService = apiService
        self.spel = spel
        self.bundle = bundle
        self.recipeRecorder = recipeRecorder
        self.language = language
    }
}
