//
//  CreaturesViewController.swift
//  hyrulecompendium
//
//  Created by Audrey Kim on 6/25/24.
//

import UIKit

class CreaturesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var creaturesData: HandleData<Creature>! // when i make this i get "no initializer error"
    let url = URL(string: "https://botw-compendium.herokuapp.com/api/v3/compendium/category/creatures")
    var datal: [Creature2] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "CreatureCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: CreatureCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        title = "Creatures"

        fetch() { result in
            // switch statement is condition used to compare (result) to case values
            switch result {
            case .success(let data):
                NSLog("success <3")
                self.datal = data
                // proceed to do whatever you want with your read data (datal) ------------------------------------------
                
                NSLog("\(self.datal[0].name)")
                NSLog("\(String(self.datal.count))")
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
                    // return data to completion success handler
                    NSLog("successful fetch")
                    NSLog("returned data: \(string)")
                    do {
                        let object = try JSONDecoder().decode(Big.self, from: data)
                        completion(.success(object.data))
                    } catch let decoderError {
                        completion(.failure(decoderError))
                    }
                }
            }
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 //creaturesData.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CreatureCell.identifier, for: indexPath) as! CreatureCell
        
        // inputing data into cells here
        
        return cell
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
