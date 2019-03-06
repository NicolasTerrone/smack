//
//  ChatVC.swift
//  smack
//
//  Created by Nicolas Terrone on 09/02/2019.
//  Copyright © 2019 Nicolas Terrone. All rights reserved.
//

import UIKit

class ChatVC: UIViewController {

    //OUTLETS
    
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var channelNameLbl: UILabel!
    @IBOutlet weak var messageTxtField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.userDataDidChanged), name: NOTIF_USER_DATA_CHANGED, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.channelSelected), name: NOTIF_CHANNEL_SELECTED, object: nil)
        
        if AuthService.instance.isLogged {
            AuthService.instance.findUserByEmail { (success) in
                if success {
                    NotificationCenter.default.post(name: NOTIF_USER_DATA_CHANGED, object: nil)
                    MessageService.instance.findAllChannel { (success) in
                    }
                }
            }
        }
    }
    
    @objc func userDataDidChanged(){
        if AuthService.instance.isLogged {
            onLoginGetMessages()
        } else {
            channelNameLbl.text = "Please Log In"
        }
    }
    
    @objc func channelSelected(){
        updateWithChannel()
    }
    
    func updateWithChannel(){
        let channelName = MessageService.instance.selectedChannel?.name ?? ""
        channelNameLbl.text = "#\(channelName)"
        getMessages()
    }
    
    func onLoginGetMessages(){
        MessageService.instance.findAllChannel { (success) in
            if success {
                if MessageService.instance.channels.count > 0 {
                    MessageService.instance.selectedChannel = MessageService.instance.channels[0]
                    self.updateWithChannel()
                } else {
                    self.channelNameLbl.text = "No Channel yet"
                }
            }
        }
    }
    
    func getMessages(){
        guard let channelId = MessageService.instance.selectedChannel?._id else { return }
        MessageService.instance.findAllMessageForChannel(channelId: channelId) { (success) in
            
        }
    }
    
    func setupView() {
        messageTxtField.attributedPlaceholder = NSAttributedString(string: "Message: ", attributes: [NSAttributedString.Key.foregroundColor : PURPLE_PLACEHOLDER])
    }

    @IBAction func sendBtnPressed(_ sender: Any) {
        if AuthService.instance.isLogged {
            guard let channelID = MessageService.instance.selectedChannel?._id else { return }
            guard let messageBody = messageTxtField.text else { return }
            SocketService.instance.addMessage(messageBody: messageBody, userID: UserDataService.instance.id, channelID: channelID) { (success) in
                if success {
                    self.messageTxtField.text = ""
                    self.messageTxtField.resignFirstResponder()
                }
            }
        }
    }
    
}
