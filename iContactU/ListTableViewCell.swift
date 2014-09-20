//
//  ListTableViewCell.swift
//  ContactU
//
//  Created by Training on 21/07/14.
//  Copyright (c) 2014 Training. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var mailButton: UIButton! = UIButton()
    @IBOutlet weak var textButton: UIButton! = UIButton()
    @IBOutlet weak var callButton: UIButton! = UIButton()
    @IBOutlet weak var nameLabel: UILabel! = UILabel()
    @IBOutlet weak var noteLabel: UILabel!  = UILabel()
    @IBOutlet weak var dueDateLabel: UILabel! = UILabel()

    @IBOutlet weak var contactImageView: UIImageView! = UIImageView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /*override func layoutSubviews() {
        super.layoutSubviews()
        
        for subview in self.subviews {
            for subview2 in (subview as UIView).subviews{
                
                let sclass:UIView = subview2 as UIView
                
                var className = NSStringFromClass(sclass.self())
                println("className: \(className)")
                if ( className == "UITableViewCellDeleteConfirmationView") {
                    (sclass.subviews.first as UIView).backgroundColor = UIColor.blueColor()
                }
                
            }
        }
    }*/

}
