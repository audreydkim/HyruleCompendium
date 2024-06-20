//
//  CompendiumViewController.swift
//  hyrulecompendium
//
//  Created by Audrey Kim on 6/19/24.
//

import UIKit

class CompendiumViewController: UIViewController {

    @IBOutlet weak var monstersButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadButtonDetails()
    }
    

    private func loadButtonDetails() {
        monstersButton.setTitle("Monsters", for: .normal)
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
