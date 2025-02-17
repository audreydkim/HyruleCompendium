//
//  CreaturesViewController.swift
//  hyrulecompendium
//
//  Created by Audrey Kim on 6/25/24.
//

import UIKit

var compendiumData : [String:[Any]] = ["Monsters": [], "Creatures": [], "Equipment": [], "Materials": [], "Treasure": []]
var compendiumImages : [String:[Any]] = ["Monsters": [], "Creatures": [], "Equipment": [], "Materials": [], "Treasure": []]
var imageCache: [String: UIImage] = [:]

class CreaturesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    

    @IBOutlet weak var label: UILabel!

    @IBOutlet weak var creatureTableView: UITableView!
    var creaturesData: HandleData<Creature>! //
    let url = URL(string: "https://botw-compendium.herokuapp.com/api/v3/compendium/category/creatures")
    var datal: [Creature2] = []
    /*var imageCache: [String: UIImage] = [:]*/ // UIImage can be found if using url string of image from api
                                            // datal[i].image = url string to image
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "CreatureCell", bundle: nil)
        creatureTableView.register(nib, forCellReuseIdentifier: CreatureCell.identifier)
        creatureTableView.dataSource = self
        creatureTableView.delegate = self
        title = "Creatures"

        if compendiumData["Creatures"]!.isEmpty {
            NSLog("compendiumData is empty")
            fetch() { [weak self] result in
                // switch statement is conditional used to compare (\result) to case values
                switch result {
                case .success(let data):
                    NSLog("successful fetch <3")
                    self?.datal = data
                    compendiumData["Creatures"] = data
                    // proceed to do whatever you want with your read data (datal) ------------------------------------------
                    DispatchQueue.main.async {
                        self?.creatureTableView.reloadData()
                    }
                case .failure(let error):
                    NSLog("unsuccessful fetch </3 error: \(error)")
                }
            }
        } else {
            NSLog("compendiumData is not empty")
            self.datal = compendiumData["Creatures"] as! [Creature2]
        }
    }
    
    func fetch(completion: @escaping (Result<[Creature2], Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            // if error is not nil, then there was an error
            if let error = error {
                completion(.failure(error))
            }
            // Safely unwrap the response; necccessary to check status code
            guard let httpResponse = response as? HTTPURLResponse else {
                //NSLog("Invalid response")
                // Handle invalid response
                completion(.failure(FetchError.invalidResponse))
                return
            }
            // Check if the status code is within success status codes, if not we return the status code to our completion handler
            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(FetchError.statusCode(String(httpResponse.statusCode))))
                // Handle the error, e.g., by returning or using a completion handler
                return
            }
            // Handle if there is no error in fetching
            if let data = data {
                let string = String(data: data, encoding: .utf8)!
                // return error if data is empty
                if string.isEmpty {
                    completion(.failure(FetchError.noData))
                } else {
                    // SUCCESS CASE
                    // NSLog("returned data: \(string)")
                    do {
                        let object = try JSONDecoder().decode(Big.self, from: data)
                        // return decoded data to completion success handler
                        completion(.success(object.data))
                    } catch let decoderError {
                        // return decoderError to completion failure handler
                        completion(.failure(decoderError))
                    }
                }
            }
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datal.count //creaturesData.data.count
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
        
        if downloader.imageCacheCheck(creatureData.image) {
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let name = datal[indexPath.row].name
        let creature = datal[indexPath.row]
        if let vc = storyboard?.instantiateViewController(withIdentifier: "CardViewController") as? CardViewController {
            vc.data = datal[indexPath.row]
            if let u = imageCache[creature.image] {
                vc.image = imageCache[creature.image]!
            } else {
                NSLog("image not found in cache \(name)")
            }
            navigationController?.pushViewController(vc, animated: true) // this allows our view to change to our view controller for the quiz we clicked on
        }
        NSLog("Selected cell \(datal[indexPath.row].name)")
    }
}

//// custom error codes to give us more information on what went wrong
//enum FetchError: Error {
//    case statusCode(String)
//    case invalidResponse
//    case noData
//    case invalidURL
//}

struct Creature2: Decodable {
    let name: String
    let id: Int
    let category: String
    let description: String
    let image: String
    let cooking_effect: String?
    let common_locations: [String]?
    let edible: Bool
    let hearts_recovered: Float?
    let dlc: Bool
}


struct Big: Decodable { // A structure to help us decode in the proper data form
    let data: [Creature2]
}

class ImageDownloader {
    
    // maybe create another function that returns true or false if we have the image already in our global variable imageCache
    public func imageCacheCheck(_ urlString: String) -> Bool {
        if (imageCache[urlString] == nil) {
            return false
        } else {
            return true
        }
    }
    
    static func downloadImage(_ urlString: String, completion: ((_ image: UIImage?, _ urlString: String?) -> ())?) {
        
       guard let url = URL(string: urlString) else {
          completion?(nil, urlString)
          return
      }
      URLSession.shared.dataTask(with: url) { (data, response,error) in
         if let error = error {
            print("error in downloading image: \(error)")
            completion?(nil, urlString)
            return
         }
         guard let httpResponse = response as? HTTPURLResponse,(200...299).contains(httpResponse.statusCode) else {
            completion?(nil, urlString)
            return
         }
         if let data = data, let image = UIImage(data: data) {
            completion?(image, urlString)
            return
         }
         completion?(nil, urlString)
      }.resume()
   }
}
