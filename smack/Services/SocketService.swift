//
//  SocketService.swift
//  smack
//
//  Created by Nicolas Terrone on 24/02/2019.
//  Copyright © 2019 Nicolas Terrone. All rights reserved.
//

import UIKit
import SocketIO

class SocketService: NSObject {

    static let instance = SocketService()
    let manager: SocketManager
    let socket: SocketIOClient
    
    override init() {
        self.manager = SocketManager(socketURL: URL(string: BASE_URL)!)
        self.socket = self.manager.defaultSocket
        super.init()
    }
    
    
    func establishConnection(){
        socket.connect()
    }
    
    func closeConnection(){
        socket.disconnect()
    }
    
    func addChannel(channelName: String, channelDescription: String, completion: @escaping CompletionHandler){
        socket.emit("newChannel", channelName, channelDescription)
        completion(true)
    }
    
    func getChannel(completion: @escaping CompletionHandler){
        socket.on("channelCreated") { (data, ack) in
            guard let channelName = data[0] as? String else { return }
            guard let channelDescription = data[1] as? String else { return }
            guard let channelId = data[2] as? String else { return }
            
            let newChannel = Channel(name: channelName, description: channelDescription, id: channelId)
            MessageService.instance.channels.append(newChannel)
            completion(true)
        }
    }
    
    func addMessage(messageBody: String, userID: String, channelID: String, completion: @escaping CompletionHandler) {
        let user = UserDataService.instance
        socket.emit("newMessage", messageBody, userID, channelID, user.name, user.avatarName, user.avatarColor )
        completion(true)
    }

}
