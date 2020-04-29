//
//  LogInfo.swift
//  SpoonacularApi
//
//  Created by Karthick Ramasamy on 4/20/20.
//  Copyright © 2020 Karthick Ramasamy. All rights reserved.
//

import Foundation

protocol Loggable {
    func toAnyObject() -> Any
}

enum UseCaseType: String {
    case login
    case depositCheck
    case billPay
    case filterRecipe
}

struct UseCase: Loggable {
    var type: UseCaseType
    var id: String
    
    func toAnyObject() -> Any {
      return [
        "type": type.rawValue,
        "id": id,
      ]
    }
}

enum Loglevel: String {
    case error
    case warning
    case info
    case verbose
}

protocol LogNameType {
    var logName: String { get }
}

struct LogInfo: Loggable {
    var useCase: UseCase
    var loglevel: Loglevel
    var logNameType: LogNameType
    var userInfo: [String: String]
    
    func toAnyObject() -> Any {
      return [
        "logName": logNameType.logName,
        "useCase": useCase.toAnyObject(),
        "loglevel": loglevel.rawValue,
        "userInfo": userInfo
      ]
    }
}

//struct DepositCheckLogger {
//    var useCase: UseCase!
//    
//    func startCheckDeposit() {
//        let useCase = UseCase(type: .depositCheck, id: UUID().uuidString)
//        let logInfo = LogInfo(useCase: useCase, loglevel: .info, userInfo: [:])
//        // send to tracking client
//    }
//    
//    func accountSelected() {
//        guard let useCase = self.useCase else {
//            fatalError("startCheckDeposit must be called")
//        }
//        let logInfo = LogInfo(useCase: useCase, loglevel: .info, userInfo: [:])
//    }
//    
//    func amountEntered() {
//        
//    }
//    
//    func makeCheckDepositTapped() {
//        
//    }
//    
//    func checkDepositCompleted() {
//        
//    }
//}
