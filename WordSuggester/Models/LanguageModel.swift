//
//  LanguageModel.swift
//  WordSuggester
//
//  Created by Vladyslav Yakovlev on 19.05.2018.
//  Copyright © 2018 Vladyslav Yakovlev. All rights reserved.
//

import Foundation

public enum Language: String {
    
    case English
}

final class LanguageModel {
    
    class func getModel(for language: Language) -> [String : Int] {
        let bundle = Bundle(identifier: "wox.WordSuggester")!
        let modelUrl = bundle.url(forResource: language.rawValue + "Model", withExtension: "txt")!
        
        let data = try! Data(contentsOf: modelUrl)
        
        let model = try! JSONSerialization.jsonObject(with: data) as! [String : Int]
        
        return model
    }
}
