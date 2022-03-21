//
//  Model.swift
//  Notes
//
//  Created by Анита Самчук on 06.02.2022.
//

import Foundation

var noteItems: [[String: String]] {
    set {
        UserDefaults.standard.set(newValue, forKey: "noteDataKey")
        UserDefaults.standard.synchronize()
    }
    get {
        if let array = UserDefaults.standard.array(forKey: "noteDataKey") as? [[String: String]] {
            return array
        } else {
            return [["title": "Приветствие", "note": "Привет!"]]
        }
    }
}

func removeItem(at index: Int) {
    noteItems.remove(at: index)
}

func moveItem(fromIndex: Int, toIndex: Int) {
    let from = noteItems[fromIndex]
    noteItems.remove(at: fromIndex)
    noteItems.insert(from, at: toIndex)
}

