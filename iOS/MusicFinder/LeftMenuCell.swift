//
//  LeftMenuCell.swift
//  MusicFinder
//
//  Created by TRAING Serey on 06/07/2017.
//  Copyright © 2017 TRAING Serey. All rights reserved.
//

import UIKit

class LeftMenuCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var view: UIView!

    
    var title: String?
    var imageURL: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func bindData(title: String?, imageName: String? = nil) {
        label.text = title
        icon.image = UIImage(named: imageName!)
        icon.tintColor = UIColor.red
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
