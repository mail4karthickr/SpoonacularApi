//
//  AppDependencyContainer.swift
//  SpoonacularApi
//
//  Created by Karthick Ramasamy on 3/30/20.
//  Copyright © 2020 Karthick Ramasamy. All rights reserved.
//

import UIKit

public class AppDependencyContainer {
    
    // MARK: - Properties
    
    // Long-lived dependencies
    var networkService: ServiceType
    
    public init() {
        func makeNetworkService() -> ServiceType {
            return MockService()
        }
        self.networkService = makeNetworkService()
    }
    
    func makeRootViewController() -> UIViewController {
        return makeRecipiesListViewController()
    }
    
    func makeRecipiesListViewController() -> RecipiesListViewController {
           let vc = RecipiesListViewController.instanceFromStoryboard()
           vc.viewModel = makeRecipiesListViewModel()
           return vc
       }
       
       func makeRecipiesListViewModel() -> RecipiesListViewModel {
           return RecipiesListViewModel(apiService: networkService)
       }
}
