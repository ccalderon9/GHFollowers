//
//  User.swift
//  myGHFollowers
//
//  Created by Clarissa Calderon on 9/3/20.
//  Copyright © 2020 clarissa. All rights reserved.
//

import Foundation

struct User: Codable {
    let login: String
    let avatarUrl: String
    var name: String?   // name, location and bio are optinal b/c user could opt to not provide this info.
    var location: String?
    var bio: String?
    let publicRepos: Int    // Even if 0, that's still an Int val.
    let publicGists: Int
    let htmlUrl: String // If user exists, will have htmlUrl
    let following: Int
    let followers: Int
    let createdAt: String
}
