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

//COLORS
let PURPLE_PLACEHOLDER = #colorLiteral(red: 0.2549019608, green: 0.3333333333, blue: 0.7803921569, alpha: 0.7)

//NOTIFICATIONS_CONSTANTS
let NOTIF_USER_DATA_CHANGED = Notification.Name("notifUserDataChanged")

//URL
let BASE_URL = "https://chattyappter.herokuapp.com/v1/"
let REGISTER_URL = "\(BASE_URL)account/register"
let LOGIN_URL = "\(BASE_URL)account/login"
let ADD_USER_URL = "\(BASE_URL)user/add"
let USER_BY_EMAIL_URL = "\(BASE_URL)user/byEmail/"
let ALL_CHANNEL_URL = "\(BASE_URL)channel"


// Segues
let TO_LOGIN = "toLogin"
let TO_CREATE_ACCOUNT = "toCreateAccount"
let UNWIND = "unwindToChannel"
let TO_AVATAR_PICKER = "toAvatarPicker"

//HEADER
let HEADER = [
    "Content-Type" : "application/json"
]

let HEADER_BEARER = [
    "Authorization" : "Bearer \(AuthService.instance.authToken)",
    "Content-Type" : "application/json"
]
