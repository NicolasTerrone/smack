//
//  ChannelCell.swift
//  smack
//
//  Created by Nicolas Terrone on 24/02/2019.
//  Copyright © 2019 Nicolas Terrone. All rights reserved.
//

import UIKit

class ChannelCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            self.layer.backgroundColor = UIColor(white: 1, alpha: 0.20).cgColor
        } else {
            self.layer.backgroundColor = UIColor.clear.cgColor
        }
    }
    
    func configureCell(channel: Channel){
        let title = channel.name ?? ""
        self.titleLbl.text = "#\(title)"
        titleLbl.font = UIFont(name: "Avenir Next Regular", size: 17.0)
        
        for id in MessageService.instance.unreadChannel {
            if channel._id == id {
                titleLbl.font = UIFont(name: "Avenir Next Bold", size: 22.0)
            }
        }
    }

}
