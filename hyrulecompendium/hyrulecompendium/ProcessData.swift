//
//  File.swift
//  hyrulecompendium
//
//  Created by Audrey Kim on 12/4/24.
//

import Foundation

// custom error codes to give us more information on what went wrong
enum FetchError: Error {
    case statusCode(String)
    case invalidResponse
    case noData
    case invalidURL
}

//struct

class ProcessData<D: Codable> {
    var Pdata: [D] = []
    let urlString: String
    
    init(_ url: String) {
        self.urlString = url
    }
    
    func startDataProcessing(completion: @escaping () -> Void) {
        
        // check if url is valid
        
        
        fetch() { [weak self] result in
            // switch statement is conditional used to compare (\result) to case values
            switch result {
            case .success(let data):
                NSLog("success <3")
                self?.Pdata = data
                NSLog("processing data: \(self?.Pdata)")
                completion()
                //compendiumData["Creatures"] = data
                // proceed to do whatever you want with your read data (datal) ------------------------------------------
                //DispatchQueue.main.async {
                    //self?.creatureTableView.reloadData()
                //}
            case .failure(let error):
                NSLog("error: \(error)")
            }
        }
    }
    
    func fetch(completion: @escaping (Result<[D], Error>) -> Void) {
        
        // check if url is valid
        guard let url = URL(string: self.urlString) else {
            completion(.failure(FetchError.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
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
                
                // encode to string to check if results are utf8 passing and if string is empty
                guard let string = String(data: data, encoding: .utf8) else {
                    completion(.failure(FetchError.invalidResponse))
                    return
                }
                
                // return error if data is empty
                if string.isEmpty {
                    completion(.failure(FetchError.noData))
                } else {
                    NSLog("successful fetch")
                    NSLog("returned data: \(string)")
                    do {
                        let object = try JSONDecoder().decode(Answer.self, from: data)
                        // return decoded data to completion success handler
                        NSLog("\(object.data)")
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
    struct Answer: Decodable {
        let data: [D]
    }

//    struct D: Decodable {
//        let category: String
//        let common_locations: [String]?
//        let description: String
//        let dlc: Bool
//        let drops: [String]?
//        let id: Int
//        let image: String
//        let name: String
//    }

}

