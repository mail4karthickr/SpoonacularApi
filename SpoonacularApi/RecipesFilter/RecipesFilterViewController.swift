//
//  RecipesFilterViewController.swift
//  SpoonacularApi
//
//  Created by Karthick Ramasamy on 4/8/20.
//  Copyright © 2020 Karthick Ramasamy. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RecipesFilterViewController: UIViewController {
    var viewModel = RecipesFilterViewModel()
    var disposeBag = DisposeBag()
    
    @IBOutlet var vegetarian: UISwitch!
    @IBOutlet var vegan: UISwitch!
    @IBOutlet var glutenFree: UISwitch!
    @IBOutlet var dairyFree: UISwitch!
    @IBOutlet var veryHealthy: UISwitch!
    @IBOutlet var cheap: UISwitch!
    @IBOutlet var veryPopular: UISwitch!
    
    @IBOutlet var clearAllButton: UIButton!
    
    static func configuredWith(recipeResponse: RecipeResponse, recipeFilter: RecipeFilter?) -> RecipesFilterViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let vc = storyboard.instantiateViewController(identifier: "RecipesFilterViewController") as! RecipesFilterViewController
        vc.modalPresentationStyle = .fullScreen
        vc.viewModel.configureWith(recipeResponse: recipeResponse, recipeFilter: recipeFilter)
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let close = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(closeButtonTapped))
        self.navigationItem.rightBarButtonItems = [close]
        self.navigationItem.title = "Recipes Filter"
        
        (vegetarian.rx.isOn <-> viewModel.vegetarianRelay)
            .disposed(by: disposeBag)
        
        (vegan.rx.isOn <-> viewModel.veganRelay)
            .disposed(by: disposeBag)
        
        (glutenFree.rx.isOn <-> viewModel.glutenFreeRelay)
            .disposed(by: disposeBag)
        
        (dairyFree.rx.isOn <-> viewModel.dairyFreeRelay)
            .disposed(by: disposeBag)
        
        (veryHealthy.rx.isOn <-> viewModel.veryHealthyRelay)
            .disposed(by: disposeBag)
        
        (cheap.rx.isOn <-> viewModel.cheapRelay)
            .disposed(by: disposeBag)
        
        (veryPopular.rx.isOn <-> viewModel.veryPopularRelay)
            .disposed(by: disposeBag)
        
        viewModel.clearAllButtonRelay
            .observeOn(MainScheduler.instance)
            .bind(to: clearAllButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.filteredRecipes.drive(onNext: { [weak self] rec in
            self?.closeButtonTapped()
        })
        .disposed(by: disposeBag)
        
        viewModel.viewDidLoad()
    }
    
    @objc func closeButtonTapped() {
        self.dismiss(animated: true)
    }
    
    @IBAction func applyFilter() {
        viewModel.applyFilter()
    }
    
    @IBAction func clearAll() {
        viewModel.resetFilter()
    }
}
