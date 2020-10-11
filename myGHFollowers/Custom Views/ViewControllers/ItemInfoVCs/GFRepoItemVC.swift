//
//  GFRepoItemVC.swift
//  myGHFollowers
//
//  Created by Clarissa Calderon on 9/17/20.
//  Copyright © 2020 clarissa. All rights reserved.
//

import UIKit

protocol GFRepoItemVCDelegate: AnyObject {    // If you need to make a delegate weak, you have to make it an object-only protocol
    func didTapGitHubProfile(for user: User)
}

class GFRepoItemVC: GFItemInfoVC {

    weak var delegate: GFRepoItemVCDelegate!  // weak delegates are always optionals!
    
    
    init(user: User, delegate: GFRepoItemVCDelegate) {
        super.init(user: user)
        self.delegate = delegate
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    
    private func configureItems() {
        itemInfoViewOne.set(itemInfoType: .repos, withCount: user.publicRepos)
        itemInfoViewTwo.set(itemInfoType: .gists, withCount: user.publicGists)
        actionButton.set(backgroundColor: .systemPurple, title: "GitHub Profile")
    }
    
   
    override func actionButtonTapped() {
        delegate.didTapGitHubProfile(for: user)
    }
}
