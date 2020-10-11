//
//  UITableView+Ext.swift
//  myGHFollowers
//
//  Created by Clarissa Calderon on 10/5/20.
//  Copyright © 2020 clarissa. All rights reserved.
//

import UIKit

extension UITableView {
    
    func removeExcessCells() {
        tableFooterView = UIView(frame: .zero)
    }
}
