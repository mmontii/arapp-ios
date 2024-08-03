//
//  EventManager.swift
//  ArCamp
//
//  Created by Mantas Ercius on 11.07.24.
//

import Foundation
import Combine

// Manages the list of events and fetches data from the internet
class EventManager: ObservableObject {
    @Published var events: [Event] = []  // List of events, updates the UI when changed
    
    private var cancellables = Set<AnyCancellable>()  // Stores data tasks to manage memory
    
    // Fetches event data based on device language setting
    func fetchEvents() {
        let locale = Locale.current.languageCode
        let urlString: String
        
        if locale == "de" {
            urlString = "https://eu-central-1.aws.data.mongodb-api.com/app/dataapp-obpgelq/endpoint/de/events"
        } else {
            urlString = "https://eu-central-1.aws.data.mongodb-api.com/app/dataapp-obpgelq/endpoint/en/events"
        }
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .print()  // Debug data fetching
            .decode(type: [Event].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching events: \(error.localizedDescription)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] events in
                print("Fetched events: \(events)")  // Debug received events
                self?.events = events.sorted(by: { $0.from < $1.from })
            })
            .store(in: &cancellables)
    }
}

// Represents an event with various details
struct Event: Identifiable, Codable {
    let id: String
    let eventTitle: String
    let from: String
    let to: String
    let coverURL: String
    let description: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case eventTitle, from, to, coverURL, description
    }
}
