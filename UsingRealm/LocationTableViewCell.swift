//
//  LocationTableViewCell.swift
//  UsingRealm
//
//  Created by Marcel Borsten on 30-04-17.
//  Copyright © 2017 Impart IT. All rights reserved.
//

import UIKit

class LocationTableViewCell: UITableViewCell {

    @IBOutlet weak var waveHeightLabel: UILabel!
    @IBOutlet weak var locationNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
