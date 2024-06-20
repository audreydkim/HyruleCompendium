//
//  ViewController.swift
//  hyrulecompendium
//
//  Created by Michaelangelo Labrador on 5/28/24.
//

import UIKit

extension UIImageView {
    // create url session pulling and download image
    func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                NSLog("Error loading image: \(error)")
                return
            }
            guard let data = data, let image = UIImage(data: data) else {
                NSLog("Failed to load image data")
                return
            }
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}

class MonsterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var monsterTableView: UITableView!
    
    var monstersData: HandleData<Monster>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        monstersData = HandleData<Monster>("https://botw-compendium.herokuapp.com/api/v3/compendium/category/monsters?game=1")
        monstersData.fetch { [weak self] in
            DispatchQueue.main.async {
                self?.monsterTableView.reloadData()
            }
        }
        
        monsterTableView.dataSource = self
        monsterTableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = monstersData.data.count
        NSLog("Number of rows in section: \(count)")
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        NSLog("Configuring cell for row at index: \(indexPath.row)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "monsterCell", for: indexPath) as! TableViewCell
        let monster = monstersData.data[indexPath.row]
        cell.monsterNameLabel.text = monster.name
        
        //
        if let imageUrl = URL(string: monster.image) {
            cell.monsterImage.loadImage(from: imageUrl)
        } else {
            NSLog("Invalid URL string: \(monster.image)")
        }
        
        return cell
    }
    
    // UITableViewDelegate method to set row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120 // Set the desired row height
    }
}
