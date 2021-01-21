//
//  BookingDetailsTableViewCell.swift
//  RoomReserve
//
//  Copyright © 2020 ALWIN VARGHESE K. All rights reserved.
//

import UIKit

class BookingDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelDetail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        labelName.text = ""
        labelDetail.text = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
