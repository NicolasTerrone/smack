//
//  AuthService.swift
//  smack
//
//  Created by Nicolas Terrone on 16/02/2019.
//  Copyright © 2019 Nicolas Terrone. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class AuthService {
    
    static let instance = AuthService()
    
    let defaults = UserDefaults.standard
    
    var isLogged: Bool {
        get {
            return defaults.bool(forKey: LOGGED_IN_KEY)
        }
        set {
            defaults.set(newValue, forKey: LOGGED_IN_KEY)
        }
    }
    
    var authToken: String{
        get {
            return defaults.value(forKey: TOKEN_KEY) as! String
        }
        set {
            defaults.set(newValue, forKey: TOKEN_KEY)
        }
    }
    
    var userEmail: String{
        get {
            return defaults.value(forKey: USER_EMAIL) as! String
        }
        set {
            defaults.set(newValue, forKey: USER_EMAIL)
        }
    }
    
    
    func registerUser (email: String, password: String, completion: @escaping CompletionHandler){
        let lowerCaseEmail = email.lowercased()
        
        
        
        let body: [String: Any] = [
            "email" : lowerCaseEmail,
            "password" : password
        ]
        
        
        Alamofire.request(REGISTER_URL, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseString { (response) in
            
            if response.result.error == nil {
                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func loginUser (email: String, password: String, completion: @escaping CompletionHandler){
        let lowCaseEmail = email.lowercased()
        
        let body: [String: Any] = [
            "email" : lowCaseEmail,
            "password" : password
        ]
        
        Alamofire.request(LOGIN_URL, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            if response.result.error == nil {
                //Method without SwiftyJson
//                if let json = response.result.value as? Dictionary<String, Any> {
//                    if let email = json["user"] as? String {
//                        self.userEmail = email
//                    }
//                    if let token = json["token"] as? String {
//                        self.authToken = token
//                    }
//                }
                
                guard let data = response.data else { return }
                do { let json = try JSON(data: data)
                    self.userEmail = json["user"].stringValue
                    self.authToken = json["token"].stringValue
                    self.isLogged = true
                } catch {
                    print("Error JSON: \(error)")
                }
                
                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
            
        }
    }
    
    func addUser(name: String, email: String, avatarName: String, avatarColor: String, completion: @escaping CompletionHandler){
        
        let lowCaseEmail = email.lowercased()
        
        
        let body: [String: Any] = [
            "name" : name,
            "email" : lowCaseEmail,
            "avatarName" : avatarName,
            "avatarColor" : avatarColor
        ]
        
        Alamofire.request(ADD_USER_URL, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER_BEARER).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else { return }
                self.setUserData(data: data)
                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func findUserByEmail(completion: @escaping CompletionHandler){
        Alamofire.request("\(USER_BY_EMAIL_URL)\(self.userEmail)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: HEADER_BEARER).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else { return }
                self.setUserData(data: data)
                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func setUserData(data: Data){
        do { let json = try JSON(data: data)
            let id = json["_id"].stringValue
            let name = json["name"].stringValue
            let email = json["email"].stringValue
            let avatarName = json["avatarName"].stringValue
            let avatarColor = json["avatarColor"].stringValue
            
            UserDataService.instance.setUserData(id: id, name: name, email: email, avatarName: avatarName, avatarColor: avatarColor)
            
        } catch {
            print("Error JSON: \(error)")
        }
    }
    
    func updateUser(name: String, completion: @escaping CompletionHandler){
        let body: [String: Any] = [
            "name" : name
        ]

        Alamofire.request("\(UPDATE_USER_URL)\(UserDataService.instance.id)", method: .put, parameters: body, encoding: JSONEncoding.default, headers: HEADER_BEARER).responseJSON { (response) in
            if response.result.error == nil {
                UserDataService.instance.setName(newName: name)
                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    
}
