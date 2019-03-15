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
    
    func getMessageByChannel(completion: @escaping CompletionHandler){
        socket.on("messageCreated") { (data, ack) in
            guard let msgBody = data[0] as? String else { return }
            guard let userId = data[1] as? String else { return }
            guard let channelID = data[2] as? String else { return }
            guard let userName = data[3] as? String else { return }
            guard let userAvatar = data[4] as? String else { return }
            guard let userAvatarColor = data[5] as? String else { return }
            guard let id = data[6] as? String else { return }
            guard let timeStamp = data[7] as? String else { return }
            
            if channelID == MessageService.instance.selectedChannel?._id && AuthService.instance.isLogged {
                let message = Message(id: id, messageBody: msgBody, userId: userId, channelId: channelID, userName: userName, userAvatar: userAvatar, userAvatarColor: userAvatarColor, timeStamp: timeStamp)
                MessageService.instance.messages.append(message)
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func getTypingUsers(_ completionHandler: @escaping (_ typingUsers: [String: String]) -> Void) {
        socket.on("userTypingUpdate") { (dataArray, ack) in
            guard let typingUsers = dataArray[0] as? [String: String] else { return }
            completionHandler(typingUsers)
        }
    }

}
