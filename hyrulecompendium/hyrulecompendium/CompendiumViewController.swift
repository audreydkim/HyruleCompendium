//
//  CompendiumViewController.swift
//  hyrulecompendium
//
//  Created by Audrey Kim on 6/19/24.
//

import UIKit

class CompendiumViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let schemas: [String] = ["Monsters", "Creatures", "Equipment", "Materials", "Treasure"]
    let images: [String] = ["monster", "horse", "sword", "pear", "treasure-chest"]
    let viewCons: [String] = ["MonsterViewController", "CreaturesViewController", "EquipmentViewController", "MaterialsViewController", "TreasureViewController"]
    
    // maybe when the compendium loads we fetch immediately... so we don't have to wait for nothing when shit happens
    @IBOutlet weak var compTableView: UITableView!
    
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "SchemaTableViewCell", bundle: nil)
        compTableView.register(nib, forCellReuseIdentifier: SchemaTableViewCell.identifier)
        // Do any additional setup after loading the view.
        compTableView.delegate = self
        compTableView.dataSource = self
        title = "Compendium"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schemas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SchemaTableViewCell.identifier, for: indexPath) as! SchemaTableViewCell
        cell.label.text = schemas[indexPath.row]
        cell.icon.image = UIImage(named: images[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        compTableView.deselectRow(at: indexPath, animated: true)
        //var vc = storyboard?.instantiateViewController(withIdentifier: viewCons[indexPath.row])
        if let vc = storyboard?.instantiateViewController(withIdentifier: viewCons[indexPath.row]) {
            let i = viewCons[indexPath.row]
            switch i {
            case "MonsterViewController" :
                vc as! MonsterViewController
            case "CreaturesViewController":
                vc as! CreaturesViewController
                // maybe load vc function?
            case "EquipmentViewController":
                vc as! EquipmentViewController
            case "MaterialsViewController":
                vc as! MaterialsViewController
            case "TreasureViewController" :
                vc as! TreasureViewController
            default :
                NSLog("there was error in defining class of scheme view controller")
            }
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // take in vc variable that's empty and load the preliminary cells with information before the vc gets pushed
    func loadVC() {
    }
    
    /*
    // MARK: - I don't think we'll need to use this.

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}
