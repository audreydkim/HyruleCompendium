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
        monsters.startDataProcessing()
        
        datal = monsters.Pdata
        NSLog("datal: \(datal)")
        monsterTableView.dataSource = self
        monsterTableView.delegate = self
        title = "Monsters"
        
        DispatchQueue.main.async {
            self.monsterTableView.reloadData()
            NSLog("monster view controller data: \(self.datal)")
        }
        
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
        // check if we already have the url in our imageCache object
//        if let image = imageCache[creatureData.image] {
//            cell.icon.image = image
//        } else {
//            // proceed to download the image if we do not have the image already saved
//            ImageDownloader.downloadImage(creatureData.image) { [weak self]
//                  image, urlString in
//                if let imageObject = image {
//                    // performing UI operation on main thread
//                    DispatchQueue.main.async {
//                        cell.icon.image = imageObject
//                        self?.imageCache[urlString!] = imageObject
//                    }
//                } else {
//                    NSLog("Image returned nil")
//                }
//            }
//        }
        return cell
    }
    
    // UITableViewDelegate method to set row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120 // Set the desired row height
    }
}
