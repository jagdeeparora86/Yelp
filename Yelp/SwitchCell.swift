//
//  SwitchCell.swift
//  Yelp
//
//  Created by Singh, Jagdeep on 10/22/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol SwitchCellDelegate {
    @objc optional func switchCell(switchCell: SwitchCell, didChanged value : Bool)
}

class SwitchCell: UITableViewCell {

    @IBOutlet weak var categorySwitch: UISwitch!
    @IBOutlet weak var categoryLabel: UILabel!
    weak var delegate:SwitchCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        categorySwitch.addTarget(self, action: #selector(SwitchCell.switchValueChanged), for: UIControlEvents.valueChanged)
    }

    func switchValueChanged(){
        delegate?.switchCell?(switchCell: self, didChanged: categorySwitch.isOn)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
