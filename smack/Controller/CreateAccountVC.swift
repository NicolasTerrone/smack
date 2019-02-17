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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //Actions
    @IBAction func chooseAvatarPressed(_ sender: Any) {
    }
    
    @IBAction func generateBGColorPressed(_ sender: Any) {
    }
    
    @IBAction func createAccountPressed(_ sender: Any) {
        guard let email = emailLbl.text, emailLbl.text != "" else { return }
        guard let password = passwordLbl.text, passwordLbl.text != "" else { return }
        
        AuthService.instance.registerUser(email: email, password: password) { (success) in
            if success {
                print("Registered user!")
            }
        }
    }
    
    @IBAction func closeBtnPressed(_ sender: Any) {
       performSegue(withIdentifier: UNWIND, sender: nil)
    }
    

}
