//
//  FollowerListVC.swift
//  myGHFollowers
//
//  Created by Clarissa Calderon on 9/1/20.
//  Copyright © 2020 clarissa. All rights reserved.
//

import UIKit

class FollowerListVC: UIViewController {

    // Put 1 param in enum b/c enums are hashable by default.
    enum Section { case main }
    
    var username: String!
    var followers: [Follower] = []  // will be passed to snapshot.appendItems().
    var filteredFollowers: [Follower] = []
    var page = 1
    var hasMoreFollowers = true
    var isSearching = false
    var isLoadingMoreFollowers = false
    var lastScrollPosition: CGFloat = 0
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    
    
    init(username: String) {
        super.init(nibName: nil, bundle: nil)
        self.username = username
        title         = username
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    deinit {
        print("deinitializing \(self)")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        configureSearchController()
        getFollowers(username: username, page: page)
        configureDataSource()
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.hidesSearchBarWhenScrolling = false
//        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
//        navigationItem.rightBarButtonItem = addButton
    }
    
    
    func configureCollectionView() {
        collectionView                 = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))// No matter what size the view is, just fill it up.
        view.addSubview(collectionView)
        collectionView.delegate        = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
    }
    

    func configureSearchController() {
        let searchController                                  = UISearchController()
        searchController.searchResultsUpdater                 = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder                = "Search for a username."
        navigationItem.searchController        = searchController
    }
    
    
    /// Calls func showLoadingView and downloads followers
    /// - Parameters:
    ///   - username: Any String as input
    ///   - page: Integer
    func getFollowers(username: String, page: Int) {
        showLoadingView()
        isLoadingMoreFollowers =  true
        // Tho true that the closure is creating a strong reference to `self`, but `self` does not have a strong reference to the closure, so no retain cycle gets created.
        NetworkManager.shared.getFollowers(for: username, page: page) { result in

            self.dismissLoadingView()
            // Check val inside our result to see whather call succeeded or failed.
            
            switch result {
            case .success(let followers):
                self.updateUI(with: followers)
                
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Bad stuff happened", message: error.rawValue, buttonTitle: "Ok")
            }
            
            self.isLoadingMoreFollowers = false
        }
    }
    
    
    func updateUI(with followers: [Follower]) {
        if followers.count < NetworkManager.shared.followersPerPage { self.hasMoreFollowers = false }
        self.followers.append(contentsOf: followers)  // passes result to our followers array.
        
        // Want to make sure we've already tried to append everything into the followers list before checking if .isEmpty.
        if self.followers.isEmpty { // isEmpty is more efficient than ==0.
            let message = "This user doesn't seem to have any followers. Go follow them 😃."
            DispatchQueue.main.async { self.showEmptyStateView(with: message, in: self.view)
                self.navigationItem.searchController = nil
            }
            return
        }
        self.updateData(on: self.followers)   // Call here b/c you know forsure you have your followers.
    }
    
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, follower) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseID, for: indexPath) as! FollowerCell
            cell.set(follower: follower)
            return cell
        
        })
    }
    
    
    func updateData(on followers: [Follower]) {
        
        // 1. Init snapshot.
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        
        // 2. Configure and populate the snapshot
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        
        DispatchQueue.main.async {
            
            // 3. Apply the snapshot.
            self.dataSource.apply(snapshot, animatingDifferences: true) // WWDC says can call apply() from bg thread, but Xcode says otherwise.
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
}

// MARK:- Extensions

extension FollowerListVC: UICollectionViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        lastScrollPosition = scrollView.contentOffset.y
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if lastScrollPosition < scrollView.contentOffset.y {
            navigationItem.hidesSearchBarWhenScrolling = true
        } else if lastScrollPosition > scrollView.contentOffset.y {
            navigationItem.hidesSearchBarWhenScrolling = false
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        let offsetY = scrollView.contentOffset.y    // How far you've scrolled down
        let contentHeight = scrollView.contentSize.height // Scroll view hight
        let height = scrollView.frame.size.height   // Screen height
        
        if offsetY > contentHeight - height {
            guard hasMoreFollowers, !isLoadingMoreFollowers else { return }
            page += 1
            getFollowers(username: username, page: page)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeArray   = isSearching ? filteredFollowers : followers
        let follower      = activeArray[indexPath.item]

        let destVC        = UserInfoVC()
        destVC.delegate   = self    // FollowerListVC now listening to UserInfoVC
        destVC.username = follower.login    // Passes username to user Info screen.
        // Put in navController that has the cancel button up there for the purposes of assistive design. Plus, navC goes with the look that ios has going on (e.g. cancel on left, Send on right)
        let navController = UINavigationController(rootViewController: destVC)
        present(navController, animated: true)
    }
}

// Everytime user changes something in search bar, it let's the app know "hey sth changed."
extension FollowerListVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        isSearching = true
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            filteredFollowers.removeAll()
            updateData(on: followers)
            isSearching = false
            return
        } // Need 2 arrays for search filter: 1. filteredFollowers, 2. followers.
        isSearching = true
        filteredFollowers = followers.filter {   $0.login.lowercased().contains(filter.lowercased()) }
        updateData(on: filteredFollowers)
    }
}

extension FollowerListVC: UserInfoVCDelegate {
    
    func didRequestFollowers(for username: String) {
        self.username = username
        title         = username
        page          = 1
        
        followers.removeAll()
        filteredFollowers.removeAll()
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)   // moves to first row of items in our collectionView.
        hasMoreFollowers = true
        getFollowers(username: username, page: page)
    }
    
    
}
