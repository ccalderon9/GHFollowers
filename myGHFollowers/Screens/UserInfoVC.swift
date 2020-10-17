//
//  UserInfoVCViewController.swift
//  myGHFollowers
//
//  Created by Clarissa Calderon on 9/13/20.
//  Copyright © 2020 clarissa. All rights reserved.
//

import UIKit

protocol UserInfoVCDelegate: AnyObject {
    func didRequestFollowers(for username: String)
}

class UserInfoVC: UIViewController {

    let scrollView          = UIScrollView()
    let contentView         = UIView()

    let headerView          = UIView()
    let itemViewOne         = UIView()
    let itemViewTwo         = UIView()
    var dateLabel           = GFMessageLabel(textAlignment: .center)
    var itemViews: [UIView] = []
    
    var favorites: [String] = []

    var username: String!
    weak var delegate: UserInfoVCDelegate!  // Must use weak if delegate is a class (val-types don't make strong reference cycles).
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getFavorites()
        configureViewController()
        configureScrollView()
        layoutUI()
        getUserInfo()
    }
    
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                         target: self,
                                         action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
        
        if favorites.contains(username) {
            let favoriteButton = UIBarButtonItem(image: SFSymbols.starFilled,
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(removeFromFavorites))
            navigationItem.leftBarButtonItem = favoriteButton
        } else {
            let favoriteButton = UIBarButtonItem(image: SFSymbols.star,
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(addToFavorites))
            navigationItem.leftBarButtonItem = favoriteButton
        }
    }
    
    
    @objc func addToFavorites() {
        showLoadingView()
        
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            guard let self = self else { return }
            self.dismissLoadingView()
            
            switch result {
            case .success(let user):
                self.addUserToFavorites(user: user);
                DispatchQueue.main.async {
                    let favoriteButton = UIBarButtonItem(image: SFSymbols.starFilled,
                                                         style: .plain,
                                                         target: self,
                                                         action: #selector(self.removeFromFavorites))
                    self.navigationItem.leftBarButtonItem = favoriteButton
                }
                
                
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    
    func addUserToFavorites(user: User) {
        let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)
        
        PersistenceManager.updateWith(favorite: favorite, actionType: .add) { [weak self] error in
            guard let self = self else { return }
            
            guard let error = error else {
                self.presentGFAlertOnMainThread(title: "Success", message: "You have successfully added \(user.login) to your Favorites! 🎉", buttonTitle: "Hooray!")
                return
            }
            
            self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
        }
    }
    
    
    @objc func removeFromFavorites() {
       showLoadingView()
       
       NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
           guard let self = self else { return }
           self.dismissLoadingView()
           
           switch result {
           case .success(let user):
               self.removeUserFromFavorites(user: user);
               DispatchQueue.main.async {
                   let favoriteButton = UIBarButtonItem(image: SFSymbols.star,
                                                        style: .plain,
                                                        target: self,
                                                        action: #selector(self.addToFavorites))
                   self.navigationItem.leftBarButtonItem = favoriteButton
               }
               
               
           case .failure(let error):
               self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
           }
       }
    }
    
    
    func removeUserFromFavorites(user: User) {
        let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)
        
        PersistenceManager.updateWith(favorite: favorite, actionType: .remove) { [weak self] error in
            guard let self = self else { return }
            
            guard let error = error else {
                self.presentGFAlertOnMainThread(title: "Removed", message: "\(user.login) has been removed from your Favorites", buttonTitle: "Ok!")
                return
            }
            
            self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
        }
    }
    
    func getFavorites() {
           PersistenceManager.retrieveFavorites { [weak self] result in
               guard let self = self else { return }
               
               switch result {
               case .success(let favorites):
                self.favorites = favorites.map({ (w) -> String in
                    return w.login
                })
                   
               case .failure(let error):
                   self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
               }
           }
       }
    
    
    func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.pinToEdges(of: view)
        contentView.pinToEdges(of: scrollView)
        
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 600)
        ])
    }
    
    
    func getUserInfo() {
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let user):
                DispatchQueue.main.async { self.configureUIElements(with: user) }

            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Something went wrong.", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    
    func configureUIElements(with user: User) {
        self.add(childVC: GFRepoItemVC(user: user, delegate: self), to: self.itemViewOne)
        self.add(childVC: GFFollowerItemVC(user: user, delegate: self), to: self.itemViewTwo)
        self.add(childVC: GFUserInfoHeaderVC(user: user), to: self.headerView)
        self.dateLabel.text = "Github since \(user.createdAt.convertToDisplayFormat())"
    }
    
    
    func layoutUI() {
        let padding: CGFloat = 20
        let itemHeight: CGFloat = 140
        
        itemViews = [headerView, itemViewOne, itemViewTwo, dateLabel]
        
        for itemView in itemViews {
            contentView.addSubview(itemView)
            itemView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                itemView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
                itemView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding)
            ])
        }

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 210),
            
            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),
            
            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
            itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),
            
            dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    
    func add(childVC: UIViewController, to containerView: UIView) {
        
        addChild(childVC)   // 1. Add the child to the parent
        containerView.addSubview(childVC.view)  // 2. Add the child's view to the parent's view
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)  // 3. Notify child that it was moved to a parent.
    }
    
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
}

// MARK:- Extensions

extension UserInfoVC: GFRepoItemVCDelegate {
    
    func didTapGitHubProfile(for user: User) {
        guard let url = URL(string: user.htmlUrl) else {
            presentGFAlertOnMainThread(title: "Invalid URL", message: "URL attached to this user is invalid.", buttonTitle: "Ok")
            return
        }

        presentSafariVC(with: url)
    }
}


extension UserInfoVC: GFFollowerItemVCDelegate {
    
    func didTapGetFollowers(for user: User) {
        guard user.followers != 0 else { presentGFAlertOnMainThread(title: "No followers", message: "This user has no followers. What a shame 😢", buttonTitle: "So sad")
            return
        }

        delegate.didRequestFollowers(for: user.login)
        dismissVC()
    }
}
