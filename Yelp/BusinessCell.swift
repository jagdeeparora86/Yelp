//
//  BusinessCell.swift
//  Yelp
//
//  Created by Singh, Jagdeep on 10/19/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {

    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var thumbImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        thumbImageView.layer.cornerRadius = 5
        thumbImageView.clipsToBounds = true
    }
    
    var buisness : Business! {
        didSet {
            guard(self.buisness.imageURL != nil) else {
                return
            }
        
            categoryLabel.text = buisness.categories!
            addressLabel.text = buisness.address!
            reviewLabel.text = "\(buisness.reviewCount!) Reviews"
            distanceLabel.text = buisness.distance!
            nameLabel.text =  buisness.name!
            thumbImageView.setImageWith(buisness.imageURL!)
            ratingImageView.setImageWith(buisness.ratingImageURL!)            
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
