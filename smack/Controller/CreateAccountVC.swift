//
//  CreateAccountVC.swift
//  smack
//
//  Created by Nicolas Terrone on 12/02/2019.
//  Copyright © 2019 Nicolas Terrone. All rights reserved.
//

import UIKit

class CreateAccountVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeBtnPressed(_ sender: Any) {
       performSegue(withIdentifier: UNWIND, sender: nil)
    }
    

}
