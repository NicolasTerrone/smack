//
//  EditProfileVC.swift
//  smack
//
//  Created by Nicolas Terrone on 25/04/2019.
//  Copyright © 2019 Nicolas Terrone. All rights reserved.
//

import UIKit

class EditProfileVC: UIViewController {
    
    //OUTLETS
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var userNameLbl: UITextField!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var bgView: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        userImg.image =  UIImage(named: UserDataService.instance.avatarName)
        userImg.backgroundColor = UserDataService.instance.returnUIColor(components: UserDataService.instance.avatarColor)
        userNameLbl.text = UserDataService.instance.name
        userEmail.text = UserDataService.instance.email
        let closeTouch = UITapGestureRecognizer(target: self, action: #selector(EditProfileVC.handTap))
        bgView.addGestureRecognizer(closeTouch)
    }

    @objc func handTap() {
        self.dismiss(animated: true, completion: nil)
    }
    
    //ACTIONS
    @IBAction func closeBtnPressed(_ sender: Any){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func validateBtnPressed(_ sender: Any){
        guard let newName = userNameLbl.text else { return }
        AuthService.instance.updateUser(name: newName) { (success) in
            if success {
                NotificationCenter.default.post(name: NOTIF_USER_DATA_CHANGED, object: nil)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
