//
//  SearchVC.swift
//  myGHFollowers
//
//  Created by Clarissa Calderon on 8/31/20.
//  Copyright © 2020 clarissa. All rights reserved.
//

// MVC mantra: Does my VC need to know about this?

import UIKit

class SearchVC: UIViewController {

    let logoImageView         = UIImageView()
    let usernameTextField     = GFTextField()// initialization also calls configure()
    let callToActionButton    = GFButton(backgroundColor: .systemGreen, title: "Get Followers")


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor        = .systemBackground// Will adapt. For lightmode: white, darkmode: black
        view.addSubviews(logoImageView, usernameTextField, callToActionButton)
        configureLogoImageView()
        configureTextField()
        configureCallToActionButton()
        createDismissKeyboardTapGesture()
    }

    // Deletes username input when phone is shaken.
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
           usernameTextField.text = ""
       }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        usernameTextField.text = "" // Clears out text field when you hit back.
        navigationController?.setNavigationBarHidden(true, animated: true) // not placed in vDL b/c only gets called once. If went back, then navBar would show again. Instead, we need it called everytime the view is about to appear.
    }

    
    func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))   // View resigns 1st responder status.
        view.addGestureRecognizer(tap)  // putting status onto the general view.
    }
    
    // Passing data
    @objc func pushFollowerListVC() {
        
        guard let username = usernameTextField.text, !username.isEmpty else {
            presentGFAlertOnMainThread(title: "Empty Username", message: "Please enter a username. We need to know who to look for!", buttonTitle: "Ok")
            return
        }
        
        let followerListVC = FollowerListVC(username: username)
        usernameTextField.resignFirstResponder()    // Dismisses keyboard as soon as "Get followers" button is tapped.
        navigationController?.pushViewController(followerListVC, animated: true)
    }

    
    func configureLogoImageView() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false // Means we'll use autoLayout
        logoImageView.image = Images.ghLogo
        
        let topConstraintConstant: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? 20 : 80
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topConstraintConstant),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    
    func configureTextField() {
        usernameTextField.delegate = self   // Setting the delegate.
        
        NSLayoutConstraint.activate([
            usernameTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),  // pins it to the bottom of the logoImageView
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),    // For trailing & bottom Anchors must use negative #.
            usernameTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    
    func configureCallToActionButton() {
        callToActionButton.addTarget(self, action: #selector(pushFollowerListVC), for: .touchUpInside)  // whenever button pressed, pushFollowerListVC is called
        
        NSLayoutConstraint.activate([
            callToActionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            callToActionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            callToActionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            callToActionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

}

// MARK:- Extensions

extension SearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushFollowerListVC()
        return true
    }
}
