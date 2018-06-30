//
//  TrieNode.swift
//  WordSuggester
//
//  Created by Vladyslav Yakovlev on 16.05.2018.
//  Copyright © 2018 Vladyslav Yakovlev. All rights reserved.
//
//

import Foundation

final class TrieNode<T: Hashable> {
    
    var value: T?
    
    weak var parentNode: TrieNode?
    
    var children = [T: TrieNode]()
    
    var isTerminating = false

    var frequency: Int?
    
    var isLeaf: Bool {
        return children.isEmpty
    }
    
    init(value: T? = nil, parentNode: TrieNode? = nil) {
        self.value = value
        self.parentNode = parentNode
    }
    
    func addChild(with value: T) {
        guard children[value] == nil else { return }
        children[value] = TrieNode(value: value, parentNode: self)
    }
}
