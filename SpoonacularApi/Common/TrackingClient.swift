//
//  TrackingClient.swift
//  SpoonacularApi
//
//  Created by Karthick Ramasamy on 4/20/20.
//  Copyright © 2020 Karthick Ramasamy. All rights reserved.
//

import UIKit

private let flushInterval = 10.0
private let chunkSize = 1

public final class TrackingClient: TrackingClientType {
    fileprivate let urlSession: URLSession
    fileprivate let queue = DispatchQueue(label: "com.spoonacular.api")
    fileprivate var buffer: [Loggable] = []
    fileprivate var timer: Timer?
    fileprivate var taskId = UIBackgroundTaskIdentifier.invalid
//    let useCaseRef = Database.database().reference(withPath: "UseCases")
//    let logInfoRef = Database.database().reference(withPath: "LogInfo")
    
    public init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
        
        let notifications = NotificationCenter.default
        notifications.addObserver(
            self,
            selector: #selector(applicationDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil)
        notifications.addObserver(
            self,
            selector: #selector(applicationDidEnterBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil)
        notifications.addObserver(
            self,
            selector: #selector(applicationWillEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil)
        notifications.addObserver(
          self,
          selector: #selector(applicationWillResignActive),
          name: UIApplication.willResignActiveNotification, object: nil
        )
        notifications.addObserver(
          self,
          selector: #selector(applicationWillTerminate),
          name: UIApplication.willTerminateNotification, object: nil
        )
        
        self.load()
        self.startTimer()
    }
    
    func track(_ logInfo: Loggable) {
        self.queue.async {
            self.buffer.append(logInfo)
        }
    }
    
    fileprivate func startTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: flushInterval, target: self, selector: #selector(self.flush), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        self.timer = nil
    }
    
    @objc fileprivate func flush() {
//        self.queue.async {
//            if self.buffer.isEmpty { return }
//            
//            while !self.buffer.isEmpty {
//                let loggable = self.buffer.first!
//                print("sending log info -- \(loggable)")
//                if loggable is UseCase {
//                    let useCase = loggable as! UseCase
//                    let child = self.useCaseRef.child("UseCase - \(useCase.id)")
//                    child.setValue(useCase.toAnyObject())
//                } else if loggable is LogInfo {
//                    let logInfo = loggable as! LogInfo
//                    let path = self.logInfoRef.child("LogId - \(logInfo.useCase.id) - \(logInfo.logNameType.logName)")
//                    path.setValue(logInfo.toAnyObject())
//                }
//                self.buffer.removeFirst(min(chunkSize, self.buffer.count))
//            }
//        }
    }
    
    func save() {
//        self.queue.async {
//            guard
//                !self.buffer.isEmpty,
//                let file = self.fileName() else {
//                return
//            }
//            NSKeyedArchiver.archiveRootObject(self.buffer, toFile: file)
//            
//            self.buffer.removeAll()
//        }
    }
    
    fileprivate func load() {
//        self.queue.async {
//            guard
//                let file = self.fileName(), FileManager.default.fileExists(atPath: file),
//                let buffer = NSKeyedUnarchiver.unarchiveObject(withFile: file) as? [LogInfo]
//                else { return }
//            
//            self.buffer = buffer + self.buffer
//            
//            _ = try? FileManager.default.removeItem(atPath: file)
//        }
    }
    
    fileprivate func fileName() -> String? {
         return NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first
             .flatMap { URL(string: $0)?.appendingPathComponent("koala.plist").absoluteString }
    }
}

extension TrackingClient {
      @objc fileprivate func applicationDidBecomeActive() {
        self.startTimer()
    }

    @objc fileprivate func applicationDidEnterBackground() {
      let handler = {
        UIApplication.shared.endBackgroundTask(convertToUIBackgroundTaskIdentifier(self.taskId.rawValue))
        self.taskId = UIBackgroundTaskIdentifier.invalid
      }

      self.taskId = UIApplication.shared.beginBackgroundTask(expirationHandler: handler)
      self.flush()
      self.save()
      self.queue.async {
        if self.taskId != UIBackgroundTaskIdentifier.invalid {
          handler()
        }
      }
    }

    @objc fileprivate func applicationWillEnterForeground() {
      self.queue.async {
        guard self.taskId != UIBackgroundTaskIdentifier.invalid else { return }
        UIApplication.shared.endBackgroundTask(convertToUIBackgroundTaskIdentifier(self.taskId.rawValue))
        self.taskId = UIBackgroundTaskIdentifier.invalid
      }
    }

    @objc fileprivate func applicationWillResignActive() {
      self.stopTimer()
    }

    @objc fileprivate func applicationWillTerminate() {
      self.save()
    }
}

// Helper function inserted by Swift 4.2 migrator.
private func convertToUIBackgroundTaskIdentifier(_ input: Int) -> UIBackgroundTaskIdentifier {
  return UIBackgroundTaskIdentifier(rawValue: input)
}
