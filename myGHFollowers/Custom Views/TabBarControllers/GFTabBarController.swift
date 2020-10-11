//
//  GFTabBarController.swift
//  myGHFollowers
//
//  Created by Clarissa Calderon on 9/28/20.
//  Copyright © 2020 clarissa. All rights reserved.
//

import UIKit

class GFTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = .systemGreen// Using 'Appearance' makes it app-wide
        viewControllers                 = [createSearchNC(), createFavoritesNC()]// TBC holds the NCs
    }

    // Func for ea. init to avoid passing in 5 param to 1 func!
    func createSearchNC() -> UINavigationController {
        let searchVC                    = SearchVC()
        searchVC.title                  = "Search"
        searchVC.tabBarItem             = UITabBarItem(tabBarSystemItem: .search, tag: 0)

        return UINavigationController(rootViewController: searchVC)
    }


    func createFavoritesNC() -> UINavigationController {
        let favoritesListVC             = FavoritesListVC()
        favoritesListVC.title           = "Favorites"
        favoritesListVC.tabBarItem      = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)

        return UINavigationController(rootViewController: favoritesListVC)
    }
}
