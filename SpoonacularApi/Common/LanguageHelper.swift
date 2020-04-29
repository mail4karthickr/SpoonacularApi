//
//  LanguageHelper.swift
//  SpoonacularApi
//
//  Created by Karthick Ramasamy on 3/30/20.
//  Copyright © 2020 Karthick Ramasamy. All rights reserved.
//

import Foundation

public enum Language: String {
    case en
    case es
    
    public static let allLanguages: [Language] = [.en, .es]
    
    static var currentLanguage: Language {
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "CurrentLanguage")
            UserDefaults.standard.synchronize()
        } get {
            guard let language = UserDefaults.standard.value(forKey: "CurrentLanguage") as? String else {
                return .en
            }
            return Language(rawValue: language) ?? .en
        }
    }
    
    func localizedString(forKey key: String) -> String {
        if key == "decodingFailed" {
            return "decodingFailed"
        } else if key == "networkNotAvailable" {
            return "networkNotAvailable"
        } else {
            return "defaultErrorMessage"
        }
    }
}
