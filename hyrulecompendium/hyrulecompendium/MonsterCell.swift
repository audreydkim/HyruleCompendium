//
//  MonsterCell.swift
//  hyrulecompendium
//
//  Created by Audrey Kim on 2/7/25.
//

import UIKit

class MonsterCell: UITableViewCell {

    static let identifier = "MonsterCell"
    
    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
