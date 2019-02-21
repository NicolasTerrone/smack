//
//  CircleImage.swift
//  smack
//
//  Created by Nicolas Terrone on 21/02/2019.
//  Copyright © 2019 Nicolas Terrone. All rights reserved.
//

import UIKit


@IBDesignable
class CircleImage: UIImageView {

    override func awakeFromNib() {
        setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }
    
    func setupView(){
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
    }

}
