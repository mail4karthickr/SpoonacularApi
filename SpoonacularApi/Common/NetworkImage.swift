//
//  NetworkImage.swift
//  SpoonacularApi
//
//  Created by Karthick Ramasamy on 4/23/20.
//  Copyright © 2020 Karthick Ramasamy. All rights reserved.
//

import UIKit

@IBDesignable
class NetworkImageView: UIImageView {
    func imageUrl(url: String) {
        guard let imageUrl = URL(string: url) else {
            return
        }
        let imageName = imageUrl.lastPathComponent
        DispatchQueue.main.async {
            self.image = UIImage(named: "default.png")
        }
        DispatchQueue.global().async {
            if let image = ImageFileManager.imageWith(name: imageName) {
                DispatchQueue.main.async {
                    self.image = image
                }
            } else {
                guard let imageData = try? Data(contentsOf: imageUrl),
                    let image = UIImage(data: imageData) else {
                        return
                }
                if let imageUrl = ImageFileManager.pathForImage(imageName) {
                     try? imageData.write(to: imageUrl)
                }
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
    }
}

class ImageFileManager {
    class func saveImage(name: String, data: Data) -> Bool {
        guard let imagePath =  pathForImage(name) else {
            return false
        }
        do {
            try data.write(to: imagePath, options: .atomic)
            return true
        } catch {
            return false
        }
    }
    
    class func imageWith(name: String) -> UIImage? {
        guard let imagePath = pathForImage(name) else {
            return nil
        }
        return UIImage(contentsOfFile: imagePath.path)
    }
    
    class func imageExists(name: String) -> Bool {
        guard let imagePath = pathForImage(name) else {
            return false
        }
        return FileManager.default.fileExists(atPath: imagePath.absoluteString)
    }
    
    class func pathForImage(_ name: String) -> URL? {
        guard var imageDirectory = ImageFileManager.imageDirectoryPath() else {
            return nil
        }
        imageDirectory.appendPathComponent(name)
        return imageDirectory
    }
    
    class func imageDirectoryPath() -> URL? {
        let documentDirectory = self.documentDirectory
        let imageDirPath = documentDirectory.appendingPathComponent("Images")
        do {
            try FileManager.default.createDirectory(atPath: imageDirPath.path, withIntermediateDirectories: true)
            return imageDirPath
        } catch {
            return nil
        }
    }
    
    class var documentDirectory: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
}
