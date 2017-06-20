//
//  ResultSearchCell.swift
//  MusicFinder
//
//  Created by TRAING Serey on 15/06/2017.
//  Copyright © 2017 TRAING Serey. All rights reserved.
//

import UIKit

class ResultSearchCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    
    var title: String?
    var imageURL: String?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func bindData(title: String?, imageURL: String? = nil) {
        titleLabel.text = title
        if imageURL != nil {
            let url = URL(string: imageURL!)
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            coverImageView.image = UIImage(data: data!)
        } else {
            coverImageView.image = nil
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
