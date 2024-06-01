import Foundation

//Structs for different schemas based on properties given
struct Monster: Codable {
    let category: String
    let common_locations: [String]?
    let description: String
    let dlc: Bool
    let drops: [String]?
    let id: Int
    let image: String
    let name: String
}

struct Property: Codable {
    let attack: Int
    let defense: Int
    let effect: String?
    let type: String?
}

struct Equipment: Codable {
    let name: String
    let id: Int
    let category: String
    let description: String
    let image: String
    let common_locations: [String]?
    let properties: Property
    let dlc: Bool
}

struct Material: Codable {
    let name: String
    let id: Int
    let catergory: String
    let description: String
    let image: String
    let common_locations: [String]?
    let hearts_recovered: Float
    let cooking_effect: String
    let dlc: Bool
}

struct Creature: Codable {
    let name: String
    let id: Int
    let category: String
    let description: String
    let image: String
    let cooking_effect: String
    let common_locations: [String]?
    let edible: Bool
    let hearts_recovered: Float
    let dlc: Bool
}

struct Treasure: Codable {
    let name: String
    let id: Int
    let category: String
    let description: String
    let image: String
    let common_locations: [String]?
    let drops: [String]?
    let dlc: Bool
}

// HandleData class to fetch data
class HandleData<T: Codable> {
    var data: [T] = []
    let url: String
    
    init(_ url: String) {
        self.url = url
    }
    
    func fetch(completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .background).async {
            guard let url = URL(string: self.url) else {
                NSLog("Invalid URL")
                return
            }
            
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                if let error = error {
                    NSLog("Error! \(error)")
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode),
                      let data = data else {
                    NSLog("Error! \(String(describing: response))")
                    return
                }
                
                do {
                    // Decode the JSON into the expected structure
                    let jsonData = try JSONDecoder().decode([String: [T]].self, from: data)
                    DispatchQueue.main.async {
                        self?.data = jsonData["data"] ?? []
                        completion()
                    }
                } catch {
                    NSLog("Error parsing JSON: \(error)")
                }
            }
            task.resume()
            NSLog("Task resumed")
        }
    }
}
