//
//  MessageExhibitionCell.swift
//  MessageApp MessagesExtension
//
//  Created by dq on 2018/5/3.
//  Copyright © 2018年 moelove. All rights reserved.
//

import UIKit

class MessageExhibitionCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 3.0
        layer.masksToBounds = true
        clipsToBounds = true
    }

}
