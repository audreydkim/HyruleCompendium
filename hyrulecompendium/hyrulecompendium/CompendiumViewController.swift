//
//  CompendiumViewController.swift
//  hyrulecompendium
//
//  Created by Audrey Kim on 6/19/24.
//

import UIKit

class CompendiumViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let schemas: [String] = ["Monsters", "Creatures", "Equipment", "Materials", "Treasure"]
//    let images: [String]
    
    @IBOutlet weak var compTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "SchemaTableViewCell", bundle: nil)
        compTableView.register(nib, forCellReuseIdentifier: SchemaTableViewCell.identifier)
        // Do any additional setup after loading the view.
        loadButtonDetails()
        compTableView.delegate = self
        compTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schemas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SchemaTableViewCell.identifier, for: indexPath) as! SchemaTableViewCell
        cell.button.setTitle(schemas[indexPath.row], for: .normal)
        return cell
    }
    
    private func loadButtonDetails() {
        //monstersButton.setTitle("Monsters", for: .normal)
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
