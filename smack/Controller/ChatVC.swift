//
//  ChatVC.swift
//  smack
//
//  Created by Nicolas Terrone on 09/02/2019.
//  Copyright © 2019 Nicolas Terrone. All rights reserved.
//

import UIKit

class ChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //OUTLETS
    
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var channelNameLbl: UILabel!
    @IBOutlet weak var messageTxtField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var msgBoxBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var userTypingLbl: UILabel!
    
    //Variables
    var isTyping = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        
        sendBtn.isHidden = true
        
        //KEYBOARD
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        let tap = UITapGestureRecognizer(target: self, action: #selector(ChatVC.handleTap))
        view.addGestureRecognizer(tap)
        
        //SOCKETS
        SocketService.instance.getMessageByChannel { (success) in
            if success {
                self.tableView.reloadData()
                self.scrollTable()
            }
        }
        
        SocketService.instance.getTypingUsers { (typingUsers) in
            guard let channelID = MessageService.instance.selectedChannel?._id else { return }
            var names = ""
            var numberOfTypers = 0
            
            for (name, channelId) in typingUsers {
                if name != UserDataService.instance.name && channelId == channelID {
                    if names == "" {
                        names = name
                    } else {
                        names = "\(names), \(name)"
                    }
                    numberOfTypers += 1
                }
            }
            
            if numberOfTypers > 0 && AuthService.instance.isLogged {
                var verb = numberOfTypers > 1 ? "are" : "is"
                self.userTypingLbl.text = "\(names) \(verb) typing..."
            } else {
                self.userTypingLbl.text = ""
            }
        }
        
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
            self.tableView.reloadData()
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
            if success {
                self.tableView.reloadData()
                self.scrollTable()
            }
        }
    }
    
    func setupView() {
        messageTxtField.attributedPlaceholder = NSAttributedString(string: "Message: ", attributes: [NSAttributedString.Key.foregroundColor : PURPLE_PLACEHOLDER])
    }

    //TABLEVIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.messages.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as? MessageCell {
            let message = MessageService.instance.messages[indexPath.row]
            cell.configureCell(message: message)
            return cell
        }
        return UITableViewCell()
    }
    
    
    //ACTIONS
    @IBAction func sendBtnPressed(_ sender: Any) {
        if AuthService.instance.isLogged {
            guard let channelID = MessageService.instance.selectedChannel?._id else { return }
            guard let messageBody = messageTxtField.text else { return }
            SocketService.instance.addMessage(messageBody: messageBody, userID: UserDataService.instance.id, channelID: channelID) { (success) in
                if success {
                    self.messageTxtField.text = ""
                    self.messageTxtField.resignFirstResponder()
                    SocketService.instance.socket.emit("stopType", UserDataService.instance.name)
                }
            }
        }
    }
    
    @IBAction func msgBoxEditing(_ sender: Any) {
        guard let channelId = MessageService.instance.selectedChannel?._id else { return }
        if messageTxtField.text != "" && AuthService.instance.isLogged {
            sendBtn.isHidden = false
            isTyping = true
            SocketService.instance.socket.emit("startType", UserDataService.instance.name, channelId)
        } else {
            sendBtn.isHidden = true
            isTyping = false
            SocketService.instance.socket.emit("stopType", UserDataService.instance.name)
        }
    }
    
    //KEYBOARD HANDLE
    
    @objc func keyboardWillShow(notification: NSNotification){
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.msgBoxBottomConstraint.constant = -keyboardHeight
            UIView.animate(withDuration: 0.2, delay: 0, options: .transitionCurlDown, animations: {
                self.view.layoutIfNeeded()
                self.scrollTable()
            }, completion: nil)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        self.msgBoxBottomConstraint.constant = 0
        UIView.animate(withDuration: 0.2, delay: 0, options: .transitionCurlDown, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    //Utilities
    func scrollTable(){
        if MessageService.instance.messages.count > 0 {
            let indexEnd = IndexPath(row: MessageService.instance.messages.count - 1, section: 0)
            self.tableView.scrollToRow(at: indexEnd, at: UITableView.ScrollPosition.bottom, animated: false)
        }
    }
}
