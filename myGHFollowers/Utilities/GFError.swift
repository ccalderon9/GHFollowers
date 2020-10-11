//
//  ErrorMessage.swift
//  myGHFollowers
//
//  Created by Clarissa Calderon on 9/4/20.
//  Copyright © 2020 clarissa. All rights reserved.
//

import Foundation

// The Raw Value is the string attached to each case.
enum GFError: String, Error {
    
    case invalidUsername  = "This username created an invalid request. Please try again."
    case unableToComplete = "Unable to completed your request. Please check your internet connection."
    case invalidResponse  = "Invalid response from the server. Please try again."
    case invalidData = "The data received from the server was invalid. Please try again."
    case unableToFavorite = "There was an error adding this user to your Favorites."
    case alreadyInFavorites = "This user is already in your favorites!"
}

/* 2 benefits of Result Type:
 1. The error we get back is now strongly typed.
 2. It's now clear that we will get back either successful data or an error--not both or neither.
*/
