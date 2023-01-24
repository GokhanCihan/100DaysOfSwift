//
//  FolderCell.swift
//  Notes App
//
//  Created by Gökhan on 23.09.2022.
//

import UIKit

class FolderCell: UITableViewCell {
    
    @IBOutlet var cellFolderImage: UIImageView!
    @IBOutlet var cellFolderTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
