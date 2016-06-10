//
//  ImageFeedItemTableViewCell.swift
//  PhotoFeed
//
//  Created by Myoung-Wan Koo on 2016. 6. 10..
//  Copyright © 2016년 Myoung-Wan Koo. All rights reserved.
//

import UIKit

class ImageFeedItemTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var itemImageView: UIImageView!

    @IBOutlet weak var itemTitle: UILabel!
    
    weak var dataTask: NSURLSessionDataTask?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
