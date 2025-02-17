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
    
    var monsters: ProcessData<Monster>!
    var datal: [Monster] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "CreatureCell", bundle: nil)
        monsters = ProcessData<Monster>("https://botw-compendium.herokuapp.com/api/v3/compendium/category/monsters") // creating our object
        
        if compendiumData["Monsters"]!.isEmpty {
            NSLog("compendiumData is empty")
            monsters.startDataProcessing { [weak self] in
                self?.datal = self?.monsters.Pdata ?? []
                // NEED TO SAVE DATA TO GLOBAL VARIABLE
                compendiumData["Monsters"] = self?.monsters.Pdata ?? []
                DispatchQueue.main.async {
                    self?.monsterTableView.reloadData()
                }
            }
        } else {
            NSLog("compendiumData is not empty")
            self.datal = compendiumData["Monsters"] as! [Monster]
        }
//        monsters.startDataProcessing { [weak self] in
//            self?.datal = self?.monsters.Pdata ?? []
//            // NEED TO SAVE DATA TO GLOBAL VARIABLE
//            compendiumData["Monsters"] = self?.monsters.Pdata ?? []
//            DispatchQueue.main.async {
//                self?.monsterTableView.reloadData()
//            }
//        }
        monsterTableView.register(nib, forCellReuseIdentifier: CreatureCell.identifier)
        monsterTableView.dataSource = self
        monsterTableView.delegate = self
        title = "Monsters"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datal.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CreatureCell.identifier, for: indexPath) as! CreatureCell
        let creatureData = datal[indexPath.row]
        // inputing data into cells here
        cell.name.text = creatureData.name.uppercased()
        cell.selectionStyle = .default
        let downloader = ImageDownloader()
        
        // check if we already have the url in our imageCache object
        if let image = imageCache[creatureData.image] {
            cell.icon.image = image
        } else {
            // proceed to download the image if we do not have the image already saved
            ImageDownloader.downloadImage(creatureData.image) { [weak self]
                  image, urlString in
                if let imageObject = image {
                    // performing UI operation on main thread
                    DispatchQueue.main.async {
                        cell.icon.image = imageObject
                        imageCache[urlString!] = imageObject
                    }
                } else {
                    NSLog("Image returned nil")
                }
            }
        }
        return cell
    }
}
