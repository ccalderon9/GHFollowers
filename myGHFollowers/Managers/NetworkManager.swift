// A singleton is a class of which exactly one instance exists, that can be globally accessed.

// NetworkManager.swift - Where errors are parsed and Handled.

import UIKit

class NetworkManager {
    
    static let shared = NetworkManager()    // Every nk Mngr will have this var on it
    private let baseURL = "https://api.github.com/users/"
    let followersPerPage = 100
    
    // 1. Create cache here. - In this file b/c we only want 1 instance of the cache and this nk Mngr is the singleton, so this nkM will have the 1 inst. of the cache. Rather than every cell having an inst. of cache. and having bunch of inst. of caches.
    // NSString = key, UIImage = value.
    let cache = NSCache<NSString, UIImage>()
    
    private init() {}   // priv ensures can only ever be initialized within the class.
    
    
    func getFollowers(for username: String, page: Int, completed: @escaping (Result<[Follower], GFError>) -> Void) {
        let endpoint = baseURL + "\(username)/followers?per_page=100&page=\(page)"
        
        // alert cannot be called here (bg thread), so instead will pass error msg as a string in the closure to our VCs that are using this b/c the VCs can present the UI.
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidUsername))
            return
        }
        
        // Url session data task to get the info back from that url.
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse?, response?.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let followers = try decoder.decode([Follower].self, from: data)
                completed(.success(followers))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
    
    
    func getUserInfo(for username: String, completed: @escaping (Result<User, GFError>) -> Void) {
           let endpoint = baseURL + "\(username)"
           
           // alert cannot be called here (bg thread), so instead will pass error msg as a string in the closure to our VCs that are using this b/c the VCs can present the UI.
           guard let url = URL(string: endpoint) else {
               completed(.failure(.invalidUsername))
               return
           }
           
           // Url session data task to get the info back from that url.
           let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
               if let _ = error {
                   completed(.failure(.unableToComplete))
                   return
               }
               
               guard let response = response as? HTTPURLResponse?, response?.statusCode == 200 else {
                   completed(.failure(.invalidResponse))
                   return
               }
               
               guard let data = data else {
                   completed(.failure(.invalidData))
                   return
               }
               
               do {
                   let decoder                  = JSONDecoder()
                   decoder.keyDecodingStrategy  = .convertFromSnakeCase
                   let user                     = try decoder.decode(User.self, from: data)
                   completed(.success(user))
               } catch {
                   completed(.failure(.invalidData))
               }
           }
           
           task.resume()
       }
    
    // Not using result type success/fail as completion handler b/c don't want to bombard user with errors for every image that doesn't properly download.
    func downloadImage(from urlString: String, completed: @escaping (UIImage?) -> Void) {
        
        let cacheKey = NSString(string: urlString)
        
        // 2. Initial check to yank from the cache. If we don't have image, then procede to the rest of the nk call (i.e. dl the image)
        if let image = cache.object(forKey: cacheKey) {
            completed(image)
            return
        }
        
        guard let url = URL(string: urlString) else {
            completed(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            // combining guard statements.
            guard let self = self,
                error == nil,
                let response = response as? HTTPURLResponse, response.statusCode == 200,
                let data = data,
                let image = UIImage(data: data) else {
                    completed(nil)
                    return
            }
            
            // 3. Set image into the cache.
            self.cache.setObject(image, forKey: cacheKey)
                completed(image)
        }
        
        task.resume()
    }
}
