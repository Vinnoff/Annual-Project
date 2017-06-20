//
//  ListGenreCell.swift
//  MusicFinder
//
//  Created by TRAING Serey on 26/03/2017.
//  Copyright © 2017 TRAING Serey. All rights reserved.
//

import UIKit

class ListGenreCell: UICollectionViewCell {

    @IBOutlet weak var label: UILabel?
    @IBOutlet weak var view: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.view.backgroundColor = UIColor.red
    }
    
    func bindData (text: String) {
        label?.text = text
    }

}
