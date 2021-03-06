//
//  GFButton.swift
//  myGHFollowers
//
//  Created by Clarissa Calderon on 8/31/20.
//  Copyright © 2020 clarissa. All rights reserved.
//

// Mark:- Reusable component #1 !

import UIKit

class GFButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    convenience init(backgroundColor: UIColor, title: String) {
        self.init(frame: .zero)
        self.backgroundColor                      = backgroundColor
        self.setTitle(title, for: .normal)
    }


    private func configure() {
        layer.cornerRadius                        = 10
        titleLabel?.font                          = UIFont.preferredFont(forTextStyle: .headline)
        setTitleColor(.white, for: .normal)
        translatesAutoresizingMaskIntoConstraints = false// Makes sure you're using Auto-Layout
    }


    func set(backgroundColor: UIColor, title: String) {
        self.backgroundColor                      = backgroundColor
        self.setTitle(title, for: .normal)
    }
}
