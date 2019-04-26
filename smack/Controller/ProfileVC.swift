//
//  ProfileVC.swift
//  smack
//
//  Created by Nicolas Terrone on 21/02/2019.
//  Copyright © 2019 Nicolas Terrone. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {
    
    //OUTLETS
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var bgView: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    @IBAction func closeBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func lougoutBtnPressed(_ sender: Any) {
        UserDataService.instance.logoutUser()
        NotificationCenter.default.post(name: NOTIF_USER_DATA_CHANGED, object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editBtnPressed(_ sender: Any) {
        let editProfile = EditProfileVC()
        editProfile.modalPresentationStyle = .custom
        present(editProfile, animated: true, completion: nil)
    }
    
    func setupView(){
        userImg.image = UIImage(named: UserDataService.instance.avatarName)
        userImg.backgroundColor = UserDataService.instance.returnUIColor(components: UserDataService.instance.avatarColor)
        usernameLbl.text = UserDataService.instance.name
        emailLbl.text = UserDataService.instance.email
        let closeTouch = UITapGestureRecognizer(target: self, action: #selector(ProfileVC.handTap))
        bgView.addGestureRecognizer(closeTouch)
    }
    
    @objc func handTap(){
        self.dismiss(animated: true, completion: nil)
    }
}
