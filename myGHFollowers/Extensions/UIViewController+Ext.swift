//
//  UIViewController+Ext.swift
//  myGHFollowers
//
//  Created by Clarissa Calderon on 9/3/20.
//  Copyright © 2020 clarissa. All rights reserved.
//

import UIKit    // importing UIKit also imports Foundation
import SafariServices

fileprivate var containerView: UIView!

extension UIViewController {
    
    // beh to show this alert controller. will be able to call this func. in any VC.
    func presentGFAlertOnMainThread(title: String, message: String, buttonTitle: String) {  // present == show modally
        DispatchQueue.main.async {  // GCD and UIview.animate closures don't need capture list.
            let alertVC = GFAlertVC(title: title, message: message, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle = .overFullScreen    // doesn't show card view.
            alertVC.modalTransitionStyle = .crossDissolve   // Fades in
            self.present(alertVC, animated: true, completion: nil)
        }
    }   // by being called here, it will always be shown in the main thread, rather than having to write it on ea VC that presents an alert.
    
    func showLoadingView() {
        containerView                 = UIView(frame: view.bounds)
        view.addSubview(containerView)

        containerView.backgroundColor = .systemBackground
        containerView.alpha           = 0

        UIView.animate(withDuration: 0.25) { containerView.alpha = 0.8 }
        
        let activityIndicator         = UIActivityIndicatorView(style: .large)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(activityIndicator)
        activityIndicator.color = .systemGreen
        // B/c (style: .large), activityIndicator already has a size, so only need to def 2 constraints instead of 4:  it's X and Y.
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
        
        activityIndicator.startAnimating()
    }
    
    // Will always be dismissing loading view from a bg thread in the closure.
    func dismissLoadingView () {
        DispatchQueue.main.async {
            containerView.removeFromSuperview()
            containerView = nil
        }
    }
    
    
    func showEmptyStateView(with message: String, in view: UIView) {
        let emptyStateView = GFEmptyStateView(message: message)
        emptyStateView.frame = view.bounds
        view.addSubview(emptyStateView)
    }
    
    
    func presentSafariVC(with url: URL) {
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemGreen
        present(safariVC, animated: true)
    }
}
