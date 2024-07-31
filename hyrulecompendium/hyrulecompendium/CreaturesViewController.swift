//
//  CreaturesViewController.swift
//  hyrulecompendium
//
//  Created by Audrey Kim on 6/25/24.
//

import UIKit

class CreaturesViewController: UIViewController,  UITableViewDataSource, UITableViewDelegate {
    

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var creaturesData: HandleData<Creature>
    
    override func viewDidLoad() {
        super.viewDidLoad()
        creaturesData = HandleData<Creature>("https://botw-compendium.herokuapp.com/api/v3/compendium/category/creatures")
        creaturesData.fetch { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        let nib = UINib(nibName: "CreatureCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: CreatureCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return creaturesData.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CreatureCell.identifier, for: indexPath) as! CreatureCell
        
        // inputing data into cells here
        
        return cell
    }
}
