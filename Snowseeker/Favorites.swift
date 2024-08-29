//
//  Favorites.swift
//  Snowseeker
//
//  Created by Kenji Dela Cruz on 8/29/24.
//

import SwiftUI

@Observable
class Favorites {
    private var resorts: Set<String>
    private let key = "Favorites"
    
    init() {
        if let data = UserDefaults.standard.data(forKey: key) {
                if let decoded = try? JSONDecoder().decode(Set<String>.self, from: data) {
                    resorts = decoded
                    return
                }
            }

            resorts = []
    }
    
    func contains(_ resort: Resort) -> Bool {
        resorts.contains(resort.id)
    }
    
    func add(_ resort: Resort) {
        resorts.insert(resort.id)
        save()
    }
    
    func remove(_ resort: Resort) {
        resorts.remove(resort.id)
        save()
    }
    
    func save() {
        if let encoded = try? JSONEncoder().encode(resorts) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }
}
