//
//  ApiError+LocalizedMessage.swift
//  SpoonacularApi
//
//  Created by Karthick Ramasamy on 3/30/20.
//  Copyright © 2020 Karthick Ramasamy. All rights reserved.
//

import Foundation

extension ApiError {
    var localizedMessage: String {
        switch self {
        case .decodingFailed:
            return Language.currentLanguage.localizedString(forKey: "decodingFailed")
        default:
            return Language.currentLanguage.localizedString(forKey: "defaultError")
        }
    }
}
