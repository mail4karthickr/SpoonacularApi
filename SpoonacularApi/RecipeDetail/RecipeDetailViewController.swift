//
//  RecipeDetailViewController.swift
//  SpoonacularApi
//
//  Created by Karthick Ramasamy on 4/14/20.
//  Copyright © 2020 Karthick Ramasamy. All rights reserved.
//

import UIKit

class RecipeDetailViewController: UIViewController {
    @IBOutlet var vegetarian: UILabel!
    @IBOutlet var vegan: UILabel!
    @IBOutlet var glutenFree: UILabel!
    @IBOutlet var dairyFree: UILabel!
    @IBOutlet var veryHealthy: UILabel!
    @IBOutlet var cheap: UILabel!
    @IBOutlet var veryPopular: UILabel!
    
    var recipe: Recipe!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vegetarian.text = recipe.vegetarian.description
        vegan.text = recipe.vegan.description
        glutenFree.text = recipe.glutenFree.description
        dairyFree.text = recipe.dairyFree.description
        veryHealthy.text = recipe.veryHealthy.description
        cheap.text = recipe.cheap.description
        veryPopular.text = recipe.veryPopular.description
    }
}
