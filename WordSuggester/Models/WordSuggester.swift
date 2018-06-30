//
//  WordSuggester.swift
//  WordSuggester
//
//  Created by Vladyslav Yakovlev on 19.05.2018.
//  Copyright © 2018 Vladyslav Yakovlev. All rights reserved.
//

import Foundation

public final class WordSuggester {
    
    var wordsCount = 8
    
    private let trie = Trie()
    
    public init(for language: Language, completion: @escaping () -> ()) {
        setupTrie(for: language) {
            completion()
        }
    }
    
    private func setupTrie(for language: Language, completion: @escaping () -> ()) {
        DispatchQueue.global(qos: .userInteractive).async {
            
            let model = LanguageModel.getModel(for: language)

            for (word, frequency) in model {
                self.trie.insert(word: word, frequency: frequency)
            }
            
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    public func getWords(with prefix: String) -> [String] {
        let trimPrefix = prefix.trimmingCharacters(in: .whitespaces)
        
        if trimPrefix.isEmpty { return [] }
        
        if let words = trie.findWords(with: trimPrefix) {
            return words.getFirst(wordsCount)
        } else {
            let editedPrefixes = wordsOnEditDistanceOne(from: trimPrefix)
            
            for editedPrefix in editedPrefixes {
                if let words = trie.findWords(with: editedPrefix, includePrefix: true) {
                    return words.getFirst(wordsCount)
                }
            }
            
            var edited2Prefixes = Set<String>()
            
            for word in editedPrefixes {
                let words = wordsOnEditDistanceOne(from: word)
                edited2Prefixes = edited2Prefixes.union(words)
            }
            
            for editedPrefix in edited2Prefixes {
                if let words = trie.findWords(with: editedPrefix, includePrefix: true) {
                    return words.getFirst(wordsCount)
                }
            }
        }
        
        return []
    }
    
    private func wordsOnEditDistanceOne(from word: String) -> Set<String> {
        if word.isEmpty { return [] }
        
        let splits = word.indices.map {
            (word[..<$0], word[$0...])
        }
        
        let deletes: [String] = splits.map {
            String($0.0 + $0.1.dropFirst())
        }
        
        let transposes: [String] = splits.map { left, right in
            if let first = right.first {
                let drop1 = right.dropFirst()
                if let second = drop1.first {
                    let drop2 = drop1.dropFirst()
                    return "\(left)\(second)\(first)\(drop2)"
                }
            }
            return ""
            }.filter { !$0.isEmpty }
        
        let alphabet = "abcdefghijklmnopqrstuvwxyz"
        
        let replaces: [String] = splits.flatMap { left, right in
            alphabet.map { "\(left)\($0)\(right.dropFirst())" }
        }
        
        let inserts: [String] = splits.flatMap { left, right in
            alphabet.map { "\(left)\($0)\(right)" }
        }
        
        return Set(deletes + transposes + replaces + inserts)
    }
}
