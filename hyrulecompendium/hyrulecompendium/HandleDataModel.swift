import Foundation

// Define the Monster data model
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

// HandleData class to fetch data
class HandleData {
    var data: [Monster] = []
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

                // Print the raw JSON data for debugging
                if let string = String(data: data, encoding: .utf8) {
                    NSLog("Raw JSON data: \(string)")
                }
                
                do {
                    // Decode the JSON into the expected structure
                    let jsonData = try JSONDecoder().decode([String: [Monster]].self, from: data)
                    DispatchQueue.main.async {
                        self?.data = jsonData["data"] ?? []
                        NSLog("Data parsed successfully: \(self?.data.count ?? 0) items")
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
