//
//  MessageService.swift
//  smack
//
//  Created by Nicolas Terrone on 24/02/2019.
//  Copyright © 2019 Nicolas Terrone. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class MessageService {
    
    static let instance = MessageService()
    
    var channels = [Channel]()
    var messages = [Message]()
    var selectedChannel : Channel?
    
    func findAllChannel(completion: @escaping CompletionHandler){
        Alamofire.request(ALL_CHANNEL_URL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: HEADER_BEARER).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else { return }
                do {
                    self.channels = try JSONDecoder().decode([Channel].self, from: data)
                    NotificationCenter.default.post(name: NOTIF_CHANNELS_LOADED, object: nil)
                } catch let error {
                    debugPrint(error as Any)
                }
                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func findAllMessageForChannel(channelId: String, completion: @escaping CompletionHandler){
        Alamofire.request("\(MESSAGE_BY_CHANNEL_URL)\(channelId)", method: .get, parameters: nil
            , encoding: JSONEncoding.default, headers: HEADER_BEARER).responseJSON { (response) in
                if response.result.error == nil {
                    guard let data = response.data else { return }
                    do {
                        self.messages = try JSONDecoder().decode([Message].self, from: data)
            
                    } catch let error {
                        debugPrint(error as Any)
                    }
                    completion(true)
                } else {
                    completion(false)
                    debugPrint(response.result.error as Any)
                }
        }
    }
    
    func clearMessages(){
        self.messages.removeAll()
    }
    
    func clearChannels(){
        self.channels.removeAll()
    }
}
