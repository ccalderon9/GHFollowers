//
//  Follower.swift
//  myGHFollowers
//
//  Created by Clarissa Calderon on 9/3/20.
//  Copyright © 2020 clarissa. All rights reserved.
//

import Foundation

// When using codeable, your var names have to match exactly what's in the data structure...
struct Follower: Codable, Hashable {
    var login: String
    var avatarUrl: String   // ... but Codeable auto converts snakeCase (avatar_url) to camelCase (avatarUrl)
}
