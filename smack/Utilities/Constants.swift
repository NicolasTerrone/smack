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
let BASE_URL = "https://chattyappter.herokuapp.com/"
let REGISTER_URL = "\(BASE_URL)account/register"


// Segues
let TO_LOGIN = "toLogin"
let TO_CREATE_ACCOUNT = "toCreateAccount"
let UNWIND = "unwindToChannel"
