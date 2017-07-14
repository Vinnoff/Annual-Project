//
//  QuizzCell.swift
//  MusicFinder
//
//  Created by TRAING Serey on 14/07/2017.
//  Copyright © 2017 TRAING Serey. All rights reserved.
//

import UIKit

class QuizzCell: UITableViewCell {

    @IBOutlet weak var view: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var creatorLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func bindData(title: String?, creator: String?) {
        titleLabel.text = title
        if creator != nil {
            creatorLabel.text = creator
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
