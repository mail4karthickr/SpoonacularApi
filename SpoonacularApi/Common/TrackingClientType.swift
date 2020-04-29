//
//  TrackingClientType.swift
//  SpoonacularApi
//
//  Created by Karthick Ramasamy on 4/22/20.
//  Copyright © 2020 Karthick Ramasamy. All rights reserved.
//

import Foundation

protocol TrackingClientType {
    func track(_ logInfo: Loggable)
}
