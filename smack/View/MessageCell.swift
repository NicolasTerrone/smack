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
        self.messageLbl.text = message.messageBody
        
        guard var isoDate = message.timeStamp else { return }
        let end  = isoDate.index(isoDate.endIndex, offsetBy: -5)
        isoDate = String(isoDate[..<end])
        
        let isoFormatter = ISO8601DateFormatter()
        let chatDate = isoFormatter.date(from: isoDate.appending("Z"))
        
        let newFormatter = DateFormatter()
        newFormatter.dateFormat = "MMM d, h:mm a"
        
        if let finalDate = chatDate {
            let finalDate = newFormatter.string(from: finalDate)
            self.timeStampLbl.text = finalDate
        }
    }
}
