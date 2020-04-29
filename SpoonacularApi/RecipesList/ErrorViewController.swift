//
//  ErrorViewController.swift
//  SpoonacularApiTests
//
//  Created by Karthick Ramasamy on 4/29/20.
//  Copyright © 2020 Karthick Ramasamy. All rights reserved.
//

import UIKit

class ErrorViewController: UIViewController {
    @IBOutlet var message1: UILabel!
    @IBOutlet var message2: UILabel!
    @IBOutlet var retry: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if AppEnvironment.current.language == .en {
            message1.text = "Unable to fetch recipes"
            message2.text = "Please try again"
            retry.setTitle("Retry", for: .normal)
        } else {
            message1.text = "Incapaz de buscar recetas"
            message2.text = "Inténtalo de nuevo"
            retry.setTitle("Procesar de nuevo", for: .normal)
        }
    }
}
