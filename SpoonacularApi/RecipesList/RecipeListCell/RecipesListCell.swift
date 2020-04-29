//
//  RecipeCell.swift
//  SpoonacularApi
//
//  Created by Karthick Ramasamy on 4/23/20.
//  Copyright © 2020 Karthick Ramasamy. All rights reserved.
//

import UIKit
import RxSwift
import Cosmos

class RecipeListCell: UITableViewCell {
    @IBOutlet var recipeImage: NetworkImageView!
    @IBOutlet var title: UILabel!
    @IBOutlet var favouriteButton: UIButton!
    @IBOutlet var ratingView: CosmosView!
    @IBOutlet var likes: UILabel!
    @IBOutlet var price: UILabel!
    
    static let cellIdentifier = "RecipeCell"
    var disposeBag = DisposeBag()
    let viewModel = RecipesListCellViewModel()
    
    func configureWith(recipe: Recipe) {
        viewModel.inputs.configureWith(recipe: recipe)
    }
    
    override func awakeFromNib() {
        self.bindViewModel()
    }
    
    func bindViewModel() {
        self.viewModel.outputs.title
            .bind(to: title.rx.text)
            .disposed(by: disposeBag)
        
        self.viewModel.outputs.likes
            .bind(to: likes.rx.text)
            .disposed(by: disposeBag)
        
        self.viewModel.outputs.price
            .bind(to: price.rx.text)
            .disposed(by: disposeBag)
        
        self.viewModel.outputs.imageUrl
            .subscribe(onNext: {  [weak self] imageUrl in
                self?.recipeImage.imageUrl(url: imageUrl)
            })
            .disposed(by: disposeBag)
        
        self.viewModel.outputs.favoriteIcon
            .bind(to: self.favouriteButton.rx.image())
            .disposed(by: disposeBag)
        
        self.viewModel.outputs.rating
            .subscribe(onNext: { [weak self] rating in
                self?.ratingView.rating = rating.rawValue
            })
            .disposed(by: disposeBag)
        
        self.favouriteButton.rx.tap
            .bind(to: self.viewModel.inputs.favoriteButton)
            .disposed(by: disposeBag)
    }
}
