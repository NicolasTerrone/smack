//
//  LoginVC.swift
//  smack
//
//  Created by Nicolas Terrone on 11/02/2019.
//  Copyright © 2019 Nicolas Terrone. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    
    //Outlets
    @IBOutlet weak var usernameLbl: UITextField!
    @IBOutlet weak var passwordLbl: UITextField!
    @IBOutlet weak var loginBtn: RoundedButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    

    @IBAction func closePressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func createAccountBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_CREATE_ACCOUNT, sender: nil)
    }
    @IBAction func loginBtnPressed(_ sender: Any) {
        guard let email = usernameLbl.text , usernameLbl.text != "" else { return }
        guard let password = passwordLbl.text , passwordLbl.text != "" else { return }
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        loginBtn.isHidden = true
        
        AuthService.instance.loginUser(email: email, password: password) { (success) in
            if success {
                AuthService.instance.findUserByEmail(completion: { (success) in
                    if success {
                        NotificationCenter.default.post(name: NOTIF_USER_DATA_CHANGED, object: nil)
                        self.activityIndicator.stopAnimating()
                        self.dismiss(animated: true, completion: nil)
                    }
                })
            } else {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                self.loginBtn.isHidden = false
            }
        }
        
    }
    
    //Setup
    func setupView(){
        activityIndicator.isHidden = true
        
        usernameLbl.attributedPlaceholder = NSAttributedString(string: "email", attributes: [NSAttributedString.Key.foregroundColor : PURPLE_PLACEHOLDER])
        passwordLbl.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedString.Key.foregroundColor : PURPLE_PLACEHOLDER])
        
    }
    
}
