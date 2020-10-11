//
//  PersistenceManager.swift
//  myGHFollowers
//
//  Created by Clarissa Calderon on 9/22/20.
//  Copyright © 2020 clarissa. All rights reserved.
//

import Foundation

enum PersistenceActionType {
    case add, remove
}

enum PersistenceManager {
    
    static private let defaults = UserDefaults.standard
    
    enum Keys { static let favorites = "favorites" }
    
    // Where we un/favorite the one indiv.
    // needs completion handler b/c can get errors if data not encoded properly so need CH that sends back an error so we can present our error message on our VC.
    static func updateWith(favorite: Follower, actionType: PersistenceActionType, completed: @escaping (GFError?) -> Void) {
        retrieveFavorites { result in
            switch result {
            case .success(var favorites):
                
                switch actionType {
                case .add:
                    guard !favorites.contains(favorite) else {  // Checks favorited user doesn't already exist.
                        completed(.alreadyInFavorites)
                        return
                    }
                    favorites.append(favorite)
                    
                case .remove:
                    favorites.removeAll { $0.login == favorite.login }
                }
                
                completed(save(favorites: favorites))
                
            case .failure(let error):
                completed(error)
            }
        }
    }
    
    // Returns a result type: either a List of favorites followers or an error.
    static func retrieveFavorites(completed: @escaping (Result<[Follower], GFError>) -> Void) {
        
        // favoritesData can be cast as Data (and not nil aka no faves) otherwise return empty array.
        guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else {
            completed(.success([]))
            return
        }
        
        do {
           let decoder = JSONDecoder()
           let favorites = try decoder.decode([Follower].self, from: favoritesData)
           completed(.success(favorites))
       } catch {
           completed(.failure(.unableToFavorite))
       }
    
    }
    
    
    static func save(favorites: [Follower]) -> GFError? {
        do {
            let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(favorites)
            
            // Save encoded favorites to the UserDefaults
            defaults.set(encodedFavorites, forKey: Keys.favorites)
            return nil
        } catch {
            return .unableToFavorite
        }
    }
    
}
