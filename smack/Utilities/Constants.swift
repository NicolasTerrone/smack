//
//  Constants.swift
//  smack
//
//  Created by Nicolas Terrone on 11/02/2019.
//  Copyright © 2019 Nicolas Terrone. All rights reserved.
//

import Foundation

typealias CompletionHandler = (_ Success: Bool) -> ()

//USER_DEFAULT
let TOKEN_KEY = "token"
let LOGGED_IN_KEY = "loggedIn"
let USER_EMAIL = "userEmail"


//URL
let BASE_URL = "https://chattyappter.herokuapp.com/v1/"
let REGISTER_URL = "\(BASE_URL)account/register"
let LOGIN_URL = "\(BASE_URL)account/login"
let ADD_USER_URL = "\(BASE_URL)user/add"


// Segues
let TO_LOGIN = "toLogin"
let TO_CREATE_ACCOUNT = "toCreateAccount"
let UNWIND = "unwindToChannel"
let TO_AVATAR_PICKER = "toAvatarPicker"

//HEADER
let HEADER = [
    "Content-Type" : "application/json"
]
