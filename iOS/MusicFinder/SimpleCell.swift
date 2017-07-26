//
//  SimpleCell.swift
//  MusicFinder
//
//  Created by TRAING Serey on 14/07/2017.
//  Copyright © 2017 TRAING Serey. All rights reserved.
//

import UIKit

class SimpleCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var view: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func bindData(title: String?) {
        if title != nil {
            label.text = title
        } else {
            label.text = ""
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
