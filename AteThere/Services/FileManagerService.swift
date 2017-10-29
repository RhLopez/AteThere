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
        let manager = FileManager.default
        self.init(with: manager)
    }
    
    func save(image: UIImage, withPath path: String) {
        let queue = DispatchQueue.global(qos: .background)
        queue.async {
            if let data = UIImagePNGRepresentation(image) {
                let filename = self.getDocumentsDirectory().appendingPathComponent(path)
                do {
                    try data.write(to: filename)
                } catch {
                    DispatchQueue.main.async {
                        print(error)
                    }
                }
            }
        }
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
