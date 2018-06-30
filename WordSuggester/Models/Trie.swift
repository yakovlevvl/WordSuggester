//
//  Trie.swift
//  WordSuggester
//
//  Created by Vladyslav Yakovlev on 16.05.2018.
//  Copyright © 2018 Vladyslav Yakovlev. All rights reserved.
//

import Foundation

final class Trie {
    
    typealias Node = TrieNode<Character>
    
    private let root = Node()
    
    private(set) var wordsCount = 0
    
    var words: [String] {
        return wordsInSubtrie(rootNode: root).map { $0.0 }
    }
    
    var isEmpty: Bool {
        return wordsCount == 0
    }
}

extension Trie {

    func insert(word: String, frequency: Int) {
        guard !word.isEmpty else {
            return
        }
        
        var currentNode = root
        let characters = Array(word.lowercased())
        
        for character in characters {
            if let childNode = currentNode.children[character] {
                currentNode = childNode
            } else {
                currentNode.addChild(with: character)
                currentNode = currentNode.children[character]!
            }
        }
        
        guard !currentNode.isTerminating else {
            return
        }
        
        wordsCount += 1
        currentNode.isTerminating = true
        currentNode.frequency = frequency
    }
    
    func contains(word: String) -> Bool {
        guard !word.isEmpty else {
            return false
        }
        
        var currentNode = root
        let characters = Array(word.lowercased())
        
        for character in characters {
            guard let childNode = currentNode.children[character] else {
                return false
            }
            currentNode = childNode
        }
        
        return currentNode.isTerminating
    }
    
    private func findLastNodeOf(word: String) -> Node? {
        var currentNode = root
        let characters = Array(word.lowercased())
        
        for character in characters {
            guard let childNode = currentNode.children[character] else {
                return nil
            }
            currentNode = childNode
        }
        
        return currentNode
    }
    
    private func findTerminalNodeOf(word: String) -> Node? {
        if let lastNode = findLastNodeOf(word: word) {
            return lastNode.isTerminating ? lastNode : nil
        }
        return nil
    }

    private func deleteNodesForWordEndingWith(terminalNode: Node) {
        var lastNode = terminalNode
        var character = lastNode.value
        while lastNode.isLeaf, let parentNode = lastNode.parentNode {
            lastNode = parentNode
            lastNode.children[character!] = nil
            character = lastNode.value
            if lastNode.isTerminating {
                break
            }
        }
    }
    
    func remove(word: String) {
        guard !word.isEmpty else {
            return
        }
        guard let terminalNode = findTerminalNodeOf(word: word) else {
            return
        }
        if terminalNode.isLeaf {
            deleteNodesForWordEndingWith(terminalNode: terminalNode)
        } else {
            terminalNode.isTerminating = false
            terminalNode.frequency = nil
        }
        wordsCount -= 1
    }
    
    private func wordsInSubtrie(rootNode: Node, partialWord: String = "") -> [(String, Int)] {
        var subtrieWords = [(String, Int)]()
        var previousLetters = partialWord
        if let value = rootNode.value {
            previousLetters.append(value)
        }
        if rootNode.isTerminating {
            subtrieWords.append((previousLetters, rootNode.frequency!))
        }
        for childNode in rootNode.children.values {
            let childWords = wordsInSubtrie(rootNode: childNode, partialWord: previousLetters)
            subtrieWords += childWords
        }
        return subtrieWords
    }

    func findWords(with prefix: String, includePrefix: Bool = false) -> [String]? {
        if prefix.isEmpty {
            return []
        }
        var words = [(String, Int)]()
        let prefixLowerCased = prefix.lowercased()
        guard let lastNode = findLastNodeOf(word: prefixLowerCased) else {
            return nil
        }
        if includePrefix, lastNode.isTerminating {
            words.append((prefixLowerCased, lastNode.frequency!))
        }
        for childNode in lastNode.children.values {
            let childWords = wordsInSubtrie(rootNode: childNode, partialWord: prefixLowerCased)
            words += childWords
        }
        
        let sortedWords = words.sorted { $0.1 > $1.1 }.map { $0.0 }
        
        return sortedWords
    }
}
