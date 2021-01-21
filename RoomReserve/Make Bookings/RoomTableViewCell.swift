//
//  RoomTableViewCell.swift
//  RoomReserve
//
//  Copyright © 2020 ALWIN VARGHESE K. All rights reserved.
//

import UIKit

class RoomTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewRoom: UIImageView!
    @IBOutlet weak var roomNumber: UILabel!
    @IBOutlet weak var noOfSeats: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
