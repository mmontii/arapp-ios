//
//  BuildingManager.swift
//  ArCamp
//
//  Created by Mantas Ercius on 11.07.24.
//

import Foundation
import Combine

// Manages the list of buildings and fetches data from the internet
class BuildingManager: ObservableObject {
    @Published var buildings: [Building] = []  // List of buildings, updates the UI when changed
    
    private var cancellables = Set<AnyCancellable>()  // Stores data tasks to manage memory
    
    // Fetches building data based on device language setting
    func fetchBuildings() {
        let locale = Locale.current.languageCode
        let urlString: String
        
        if locale == "de" {
            urlString = "https://eu-central-1.aws.data.mongodb-api.com/app/dataapp-obpgelq/endpoint/buildings"
        } else {
            urlString = "https://eu-central-1.aws.data.mongodb-api.com/app/dataapp-obpgelq/endpoint/buildings_en"
        }
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .print()  // Debug data fetching
            .decode(type: [Building].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching buildings: \(error.localizedDescription)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] buildings in
                print("Fetched buildings: \(buildings)")  // Debug received buildings
                self?.buildings = buildings
            })
            .store(in: &cancellables)
    }
}

// Represents a building with various details
struct Building: Identifiable, Codable {
    let id: String
    let name: String
    let campus: String
    let address: String
    let enterances: [Entrance]
    let latitude: Double
    let longitude: Double
    let description: String
    let hours_of_operation: HoursOfOperation
    let facilities: [String]
    let departaments: [String]
    let shortName: String
    let imageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, campus, address, enterances, latitude, longitude, description, hours_of_operation, facilities, departaments, shortName, imageUrl
    }
}

// Represents an entrance of a building
struct Entrance: Identifiable, Codable {
    let id = UUID()
    let type: String
    let accessible: Bool
    let elivator: Bool
    let latitude: Double
    let longitude: Double
}

// Represents the operating hours of a building
struct HoursOfOperation: Codable {
    let monday_to_friday: String
    let saturday: String
}
