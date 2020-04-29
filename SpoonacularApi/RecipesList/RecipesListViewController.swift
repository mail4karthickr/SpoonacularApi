//
//  RecipiesListViewController.swift
//  SpoonacularApi
//
//  Created by Karthick Ramasamy on 3/30/20.
//  Copyright © 2020 Karthick Ramasamy. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxSwiftExt

class RecipesListViewController: UIViewController, StoryboardInstantiable {
    @IBOutlet var tableView: UITableView!
    
    private var disposeBag = DisposeBag()
    
    fileprivate var recipeResponse: RecipeResponse?
    fileprivate var recipeFilter: RecipeFilter?
    fileprivate var recipes: [Recipe]?
    
    var viewModel = RecipesListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let filter = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(applyFilter))
        navigationItem.rightBarButtonItems = [filter]
        self.navigationItem.title = "Recipes List"
        
        viewModel.outputs.getRecipiesFailure.drive(onNext: { error in
            let storyboard = UIStoryboard(name: "Main", bundle: AppEnvironment.current.bundle)
            let vc = storyboard.instantiateViewController(identifier: "ErrorViewController")
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: false)
        })
        .disposed(by: disposeBag)
        
        viewModel.outputs.recipes.drive(onNext: {
            self.recipes = $0
            self.tableView.reloadData()
        })
        .disposed(by: disposeBag)
        
        viewModel.outputs.recipeResponse.drive(onNext: { [weak self] recipeResponse in
            self?.recipeResponse = recipeResponse
        })
        .disposed(by: disposeBag)
        
        viewModel.outputs.shouldShowActivityIndicator
            .do(onNext: { err in
                       print(err)
                   })
            .drive(UIApplication.shared.rx.isNetworkActivityIndicatorVisible)
            .disposed(by: disposeBag)
        
        viewModel.inputs.viewDidLoad()
    }
    
    @objc func applyFilter() {
        guard let recipeResponse = self.recipeResponse else { return }
        AppEnvironment.current.spel.startRecipeFilterUseCase()
        let vc = RecipesFilterViewController.configuredWith(recipeResponse: recipeResponse, recipeFilter: recipeFilter)
        vc.viewModel.filteredRecipes
            .drive(viewModel.inputs.filteredRecipes)
            .disposed(by: disposeBag)
        
        vc.viewModel.appliedFilters.drive(onNext: {
            self.recipeFilter = $0
        })
        .disposed(by: disposeBag)
        
        let navController = UINavigationController(rootViewController: vc)
        self.present(navController, animated: true)
    }
}

extension RecipesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         guard let recipe = recipes?[indexPath.row] else {
                   return
        }
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let detailVC = storyboard.instantiateViewController(identifier: "RecipeDetailViewController") as! RecipeDetailViewController
        detailVC.recipe = recipe
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension RecipesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecipeListCell.cellIdentifier, for: indexPath) as! RecipeListCell
        guard let recipe = recipes?[indexPath.row] else {
            return cell
        }
        cell.configureWith(recipe: recipe)
        return cell
    }
}
