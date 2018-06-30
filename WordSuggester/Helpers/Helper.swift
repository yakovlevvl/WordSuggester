//
//  Helper.swift
//  WordSuggester
//
//  Created by Vladyslav Yakovlev on 18.05.2018.
//  Copyright © 2018 Vladyslav Yakovlev. All rights reserved.
//

import Foundation

extension FileManager {
    
    func directoryExists(_ path: String) -> Bool {
        var isDirectory = ObjCBool(true)
        let exists = fileExists(atPath: path, isDirectory: &isDirectory)
        return exists && isDirectory.boolValue
    }
}

extension Array {
    
    func getFirst(_ itemsCount: Int) -> [Element] {
        let croppedArray: [Element]
        
        if count > itemsCount {
            croppedArray = Array(self[0...itemsCount - 1])
        } else {
            croppedArray = self
        }
        
        return croppedArray
    }
}
