//
//  TrainingTVCell.swift
//  MWGuerraNeuralSim
//
//  Created by Marcelo Wanderley Guerra on 09/10/17.
//  Copyright © 2017 Marcelo Wanderley Guerra. All rights reserved.
//

import UIKit

class TrainingTVCell: UITableViewCell {

    @IBOutlet weak var cellInputLabel1: UILabel!
    @IBOutlet weak var cellInputLabel2: UILabel!
    @IBOutlet weak var cellInputLabel3: UILabel!
    @IBOutlet weak var cellOutputLabel1: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
