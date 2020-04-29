//
//  TestCase.swift
//  SpoonacularApiTests
//
//  Created by Karthick Ramasamy on 4/28/20.
//  Copyright © 2020 Karthick Ramasamy. All rights reserved.
//

import Foundation
import XCTest

class MockTrackingClient: TrackingClientType {
    func track(_ logInfo: Loggable) {
        print("logInfo")
    }
}

class TestCase: XCTestCase {
    let apiService = MockService()
    let trackingClient = MockTrackingClient()
    let recipeRecorder = MockFavoriteRecipeRecorder()
    
    override func setUp() {
        super.setUp()
        
        AppEnvironment.pushEnvironment(
            apiService: self.apiService,
            spel: Spel(client: self.trackingClient),
            bundle: Bundle(for: TestCase.self),
            recipeRecorder: recipeRecorder,
            language: .en
        )
    }
}
