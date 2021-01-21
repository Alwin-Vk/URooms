//
//  findTableViewCell.swift
//  RoomReserve
//
//  Created by ALWIN VARGHESE K on 29/08/2020.
//  Copyright © 2020 ALWIN VARGHESE K. All rights reserved.
//

import UIKit

class findTableViewCell: UITableViewCell {

    @IBOutlet weak var imageView_Room: UIImageView!
    
    @IBOutlet weak var label_roomName: UILabel!
    @IBOutlet weak var label_capacity: UILabel!
    
    @IBOutlet weak var label_blockName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
