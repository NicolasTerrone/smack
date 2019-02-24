//
//  AddChannelVC.swift
//  smack
//
//  Created by Nicolas Terrone on 24/02/2019.
//  Copyright © 2019 Nicolas Terrone. All rights reserved.
//

import UIKit

class AddChannelVC: UIViewController {

    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var descTxt: UITextField!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var formView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    
    func setupView(){
        nameTxt.attributedPlaceholder = NSAttributedString(string: "name", attributes: [NSAttributedString.Key.foregroundColor : PURPLE_PLACEHOLDER])
        descTxt.attributedPlaceholder = NSAttributedString(string: "description", attributes: [NSAttributedString.Key.foregroundColor : PURPLE_PLACEHOLDER])
        let closeTap = UITapGestureRecognizer(target: self, action: #selector(AddChannelVC.handTap))
        bgView.addGestureRecognizer(closeTap)
        let closeKeyBoard = UITapGestureRecognizer(target: self, action: #selector(AddChannelVC.endEdit))
        formView.addGestureRecognizer(closeKeyBoard)
    }
    
    @objc func handTap(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func endEdit(){
        formView.endEditing(true)
    }
    
    //IBACTION
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createChannelPressed(_ sender: Any) {
        guard let name = nameTxt.text, nameTxt.text != "" else { return  }
        guard let description = descTxt.text, descTxt.text != "" else { return }
        SocketService.instance.addChannel(channelName: name, channelDescription: description) { (success) in
            if success {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
    
}
