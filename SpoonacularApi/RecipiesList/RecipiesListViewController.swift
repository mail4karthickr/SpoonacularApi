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

class RecipiesListViewController: UIViewController, StoryboardInstantiable {
    @IBOutlet var tableView: UITableView!
    
    var viewModel: RecipiesListViewModel!
    
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        
        viewModel.outputs.shouldShowActivityIndicator.drive(onNext: { show in
            print("ShouldShow --- \(show)")
        })
        .disposed(by: disposeBag)
        
        viewModel.inputs.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Observable.just(["one", "two"])
                  .asDriver(onErrorJustReturn: ["one", "two"])
                  .drive(tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (index, recipe, cell) in
                      cell.textLabel?.text = recipe
              }
              .disposed(by: disposeBag)
    }
}
