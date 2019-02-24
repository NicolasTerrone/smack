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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    
    func setupView(){
        nameTxt.attributedPlaceholder = NSAttributedString(string: "name", attributes: [NSAttributedString.Key.foregroundColor : PURPLE_PLACEHOLDER])
        descTxt.attributedPlaceholder = NSAttributedString(string: "description", attributes: [NSAttributedString.Key.foregroundColor : PURPLE_PLACEHOLDER])
        let closeTap = UIGestureRecognizer(target: self, action: #selector(AddChannelVC.handTap))
        bgView.addGestureRecognizer(closeTap)
    }
    
    @objc func handTap(){
        dismiss(animated: true, completion: nil)
    }
    
    //IBACTION
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createChannelPressed(_ sender: Any) {
        
    }
    
    
    
}
