//
//  MenuTableViewCell.swift
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    @IBOutlet weak var imageViewIcon: UIImageView!
    @IBOutlet weak var labelName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        labelName.text = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
