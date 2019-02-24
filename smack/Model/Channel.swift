//
//  Channel.swift
//  smack
//
//  Created by Nicolas Terrone on 24/02/2019.
//  Copyright © 2019 Nicolas Terrone. All rights reserved.
//

import Foundation

struct Channel : Decodable {
    public private(set) var _id: String!
    public private(set) var description: String!
    public private(set) var name: String!
    public private(set) var __v: Int?
    
    init(name: String, description: String, id: String) {
        self._id = id
        self.description = description
        self.name = name
    }
}
