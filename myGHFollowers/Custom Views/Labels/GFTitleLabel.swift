//
//  GFTitleLabel.swift
//  myGHFollowers
//
//  Created by Clarissa Calderon on 9/1/20.
//  Copyright © 2020 clarissa. All rights reserved.
//

import UIKit

class GFTitleLabel: UILabel {
    
    // Designated initialier: one of the req'd init for the obj.
    // Init with frame is a Design. Init. for UILabel.
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Convenience Init has to call one of the Des.Init. Eliminates need to called configure() in both default and custom init.
    convenience init(textAlignment: NSTextAlignment, fontSize: CGFloat) {
        self.init(frame: .zero)
        self.textAlignment = textAlignment
        self.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
    }
    
    
    private func configure() {
        textColor                                 = .label
        adjustsFontSizeToFitWidth                 = true
        minimumScaleFactor                        = 0.9
        lineBreakMode                             = .byTruncatingTail
        translatesAutoresizingMaskIntoConstraints = false
    }
}
