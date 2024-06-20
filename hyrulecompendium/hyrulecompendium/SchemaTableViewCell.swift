//
//  SchemaTableViewCell.swift
//  hyrulecompendium
//
//  Created by Audrey Kim on 6/19/24.
//

import UIKit

class SchemaTableViewCell: UITableViewCell {
    
    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var label: UILabel!
    let schemas: [String] = ["Monsters", "Creatures", "Equipment", "Materials", "Treasure"]
    static let identifier = "SchemaTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
