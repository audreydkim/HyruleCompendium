//
//  CreaturesViewController.swift
//  hyrulecompendium
//
//  Created by Audrey Kim on 6/25/24.
//

import UIKit

class CreaturesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    

    @IBOutlet weak var label: UILabel!

    @IBOutlet weak var creatureTableView: UITableView!
    var creaturesData: HandleData<Creature>! // when i make this i get "no initializer error"
    let url = URL(string: "https://botw-compendium.herokuapp.com/api/v3/compendium/category/creatures")
    var datal: [Creature2] = []
    var imageCache: [String: UIImage] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "CreatureCell", bundle: nil)
        creatureTableView.register(nib, forCellReuseIdentifier: CreatureCell.identifier)
        creatureTableView.dataSource = self
        creatureTableView.delegate = self
        title = "Creatures"

        fetch() { [weak self] result in
            // switch statement is condition used to compare (result) to case values
            switch result {
            case .success(let data):
                NSLog("success <3")
                self?.datal = data
                // proceed to do whatever you want with your read data (datal) ------------------------------------------
                DispatchQueue.main.async {
                    self?.creatureTableView.reloadData()
                }
            case .failure(let error):
                NSLog("error: \(error)")
            }
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
                    NSLog("successful fetch")
                    NSLog("returned data: \(string)")
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
                        self?.imageCache[urlString!] = imageObject
                    }
                } else {
                    NSLog("Image returned nil")
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        NSLog("Selected cell \(datal[indexPath.row].name)")
    }
    
}

// custom error codes to give us more information on what went wrong
enum FetchError: Error {
    case statusCode(String)
    case invalidResponse
    case noData
}

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

struct Big: Decodable {
    let data: [Creature2]
}

class ImageDownloader {
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
