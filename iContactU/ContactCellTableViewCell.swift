//
//  ContactCellTableViewCell.swift
//  ContactU
//
//  Created by Training on 21/07/14.
//  Copyright (c) 2014 Training. All rights reserved.
//

import UIKit

class ContactCellTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel! = UILabel()
    @IBOutlet weak var phoneLabel: UILabel! = UILabel()
    @IBOutlet weak var emailLabel: UILabel! = UILabel()
    @IBOutlet weak var contactImageView: UIImageView! = UIImageView()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        //RESIZE IMAGE VIEW!
        self.contactImageView.frame = CGRectMake(0, 0, 75, 75)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
