//
//  NoteCell.swift
//  Notes App
//
//  Created by Gökhan on 22.09.2022.
//

import UIKit

class NoteCell: UITableViewCell {

    @IBOutlet var cellNoteTitle: UILabel!
    @IBOutlet var cellDateEdited: UILabel!
    @IBOutlet var cellBodyText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
