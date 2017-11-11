//
//  FileManagerService.swift
//  AteThere
//
//  Created by Ramiro H Lopez on 10/28/17.
//  Copyright © 2017 Ramiro H Lopez. All rights reserved.
//

import Foundation
import UIKit

class FileManagerService {
    private let fileManager: FileManager
    
    init(with fileManager: FileManager) {
        self.fileManager = fileManager
    }
    
    convenience init() {
        self.init(with: .default)
    }
    
    func save(image: UIImage, withPath path: String) {
        if let data = UIImagePNGRepresentation(image) {
            let filename = self.getDocumentsDirectory().appendingPathComponent(path)
            do {
                try data.write(to: filename)
                print("fileSaved: \(filename)")
            } catch {
                DispatchQueue.main.async {
                    print(error)
                }
            }
        }
    }
    
    func loadImage(withPath path: String, completion: @escaping (UIImage?) -> Void) {
        var savedImage: UIImage?
        let queue = DispatchQueue.global(qos: .userInitiated)
        queue.async {
            let directory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
            let filename = directory.appendingPathComponent(path)
            if let image = UIImage(contentsOfFile: filename) {
                savedImage = image
            }
            
            DispatchQueue.main.async {
                completion(savedImage)                
            }
        }
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
