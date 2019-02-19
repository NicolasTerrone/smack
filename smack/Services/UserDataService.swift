//
//  UserDataService.swift
//  smack
//
//  Created by Nicolas Terrone on 18/02/2019.
//  Copyright © 2019 Nicolas Terrone. All rights reserved.
//

import Foundation

class UserDataService {
    
    static let instance = UserDataService()
    
    public private(set) var id = ""
    public private(set) var name = ""
    public private(set) var email = ""
    public private(set) var avatarName = ""
    public private(set) var avatarColor = ""
    
    func setUserData(id: String, name: String, email: String, avatarName: String, avatarColor: String){
        self.id = id
        self.name = name
        self.email = email
        self.avatarName = avatarName
        self.avatarColor = avatarColor
    }
    
    func setAvatarName(avatarName: String){
        self.avatarName = avatarName
    }
}
