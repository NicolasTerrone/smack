//
//  MessageCell.swift
//  smack
//
//  Created by Nicolas Terrone on 06/03/2019.
//  Copyright © 2019 Nicolas Terrone. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    //OUTLETS
    @IBOutlet weak var avatarImg: CircleImage!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var timeStampLbl: UILabel!
    @IBOutlet weak var messageLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configureCell(message: Message) {
        self.avatarImg.image = UIImage(named: message.userAvatar)
        self.avatarImg.backgroundColor = UserDataService.instance.returnUIColor(components: message.userAvatarColor)
        self.nameLbl.text = message.userName
    }
}
