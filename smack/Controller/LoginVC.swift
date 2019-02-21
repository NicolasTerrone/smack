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
    
    //Setup
    func setupView(){
        usernameLbl.attributedPlaceholder = NSAttributedString(string: "username", attributes: [NSAttributedString.Key.foregroundColor : PURPLE_PLACEHOLDER])
        passwordLbl.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedString.Key.foregroundColor : PURPLE_PLACEHOLDER])
        
    }
    
}
