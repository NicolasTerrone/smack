//
//  CreateAccountVC.swift
//  smack
//
//  Created by Nicolas Terrone on 12/02/2019.
//  Copyright © 2019 Nicolas Terrone. All rights reserved.
//

import UIKit

class CreateAccountVC: UIViewController {
    
    //Outlets
    @IBOutlet weak var usernameLbl: UITextField!
    @IBOutlet weak var emailLbl: UITextField!
    @IBOutlet weak var passwordLbl: UITextField!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var acitivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var createAccountBtn: RoundedButton!
    
    //Variables
    var avatarName = "profileDefault"
    var avatarColor = "[0.5, 0.5, 0.5, 1]"
    var bgColor: UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDataService.instance.avatarName != "" {
            avatarName = UserDataService.instance.avatarName
            profileImg.image = UIImage(named: avatarName)
            if avatarName.contains("light") && bgColor == nil {
                profileImg.backgroundColor = UIColor.lightGray
            }
        }
    }
    
    //Actions
    @IBAction func chooseAvatarPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_AVATAR_PICKER, sender: nil)
    }
    
    @IBAction func generateBGColorPressed(_ sender: Any) {
        let red = CGFloat(arc4random_uniform(255)) / 255
        let green = CGFloat(arc4random_uniform(255)) / 255
        let blue = CGFloat(arc4random_uniform(255)) / 255
        UIView.animate(withDuration: 0.2) {
            self.profileImg.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1)
            self.bgColor = self.profileImg.backgroundColor
        }
    }
    
    @IBAction func createAccountPressed(_ sender: Any) {
        guard let email = emailLbl.text, emailLbl.text != "" else { return }
        guard let password = passwordLbl.text, passwordLbl.text != "" else { return }
        guard let name = usernameLbl.text, usernameLbl.text != "" else { return }
        createAccountBtn.isHidden = true
        acitivityIndicator.isHidden = false
        acitivityIndicator.startAnimating()
        
        
        AuthService.instance.registerUser(email: email, password: password) { (success) in
            if success {
                AuthService.instance.loginUser(email: email, password: password, completion: { (success) in
                    if success {
                        AuthService.instance.addUser(name: name, email: email, avatarName: self.avatarName, avatarColor: self.avatarColor, completion: { (success) in
                            if success {
                                print(UserDataService.instance.name, UserDataService.instance.avatarName)
                                self.acitivityIndicator.stopAnimating()
                                NotificationCenter.default.post(name: NOTIF_USER_DATA_CHANGED, object: nil)
                                self.performSegue(withIdentifier: UNWIND, sender: nil)
                            }
                        })
                    }
                })
            }
        }
    }
    
    @IBAction func closeBtnPressed(_ sender: Any) {
       performSegue(withIdentifier: UNWIND, sender: nil)
    }
    
    
    //Setup
    func setupView(){
        acitivityIndicator.isHidden = true
        usernameLbl.attributedPlaceholder = NSAttributedString(string: "username", attributes: [NSAttributedString.Key.foregroundColor : PURPLE_PLACEHOLDER])
        emailLbl.attributedPlaceholder = NSAttributedString(string: "email", attributes: [NSAttributedString.Key.foregroundColor : PURPLE_PLACEHOLDER])
        passwordLbl.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedString.Key.foregroundColor : PURPLE_PLACEHOLDER])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(CreateAccountVC.handleTap))
        view.addGestureRecognizer(tap)
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    

}
