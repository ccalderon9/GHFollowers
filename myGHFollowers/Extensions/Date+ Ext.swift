//
//  Date+ Ext.swift
//  myGHFollowers
//
//  Created by Clarissa Calderon on 9/17/20.
//  Copyright © 2020 clarissa. All rights reserved.
//
// Have in 2 separate steps b/c common funcs I will use.

import Foundation

extension Date {
        
    func convertToMonthYearFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        
        return dateFormatter.string(from: self)
    }

}
