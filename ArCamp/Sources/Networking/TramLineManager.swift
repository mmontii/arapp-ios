//
//  TramLineManager.swift
//  ArCamp
//
//  Created by Mantas Ercius on 11.07.24.
//

import Foundation
import Combine

// Manages the list of tram lines and fetches data from the internet
class TramLineManager: ObservableObject {
    @Published var tramLines: [TramLine] = []  // List of tram lines, updates the UI when changed
    
    private var cancellables = Set<AnyCancellable>()  // Stores data tasks to manage memory
    
    // Fetches tram line data from the internet
    func fetchTramLines() {
        guard let url = URL(string: "https://eu-central-1.aws.data.mongodb-api.com/app/dataapp-obpgelq/endpoint/tramlines") else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [TramLine].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching tram lines: \(error.localizedDescription)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] tramLines in
                self?.tramLines = tramLines
            })
            .store(in: &cancellables)
    }
}

// Represents a tram line with various details
struct TramLine: Identifiable, Codable {
    let id: String
    let line: String
    let destination: String
    let start_time: String
    let end_time: String
    let interval_minutes: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case line, destination, start_time, end_time, interval_minutes
    }
}
