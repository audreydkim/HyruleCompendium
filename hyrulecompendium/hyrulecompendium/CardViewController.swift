//
//  CardViewController.swift
//  hyrulecompendium
//
//  Created by Audrey Kim on 10/1/24.
//

import UIKit

class CardViewController: UIViewController {

    static let identifier = "CardViewController"
    @IBOutlet weak var creatureName: UILabel!
    @IBOutlet weak var creatureImage: UIImageView!
    
    @IBOutlet weak var edibleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var effectsLabel: UILabel!
    @IBOutlet weak var foundLabel: UILabel!
    var data: Creature2!
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        creatureImage.image = image
        creatureName.text = data.name.uppercased()
        if data.edible {
            edibleLabel.text = "Edible"
        } else {
            edibleLabel.text = "Inedible"
        }
        if var effect = data.cooking_effect {
            effectsLabel.text = effect
        } else {
            effectsLabel.text = "No effect"
        }
        descriptionLabel.text = data.description
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
