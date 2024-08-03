//
//  HomeView.swift
//  ArCamp
//
//  Created by Mantas Ercius on 09.07.24.
//

import SwiftUI

// View displaying lists of active, upcoming, and past events
struct HomeView: View {
    @StateObject private var eventManager = EventManager()  // Manages event data
    @State private var showAllUpcoming = false  // Controls the display of all upcoming events
    
    var body: some View {
        NavigationView {
            List {
                // Section for active events
                Section(header: Text(NSLocalizedString("Active Events", comment: "Header for active events section"))) {
                    ForEach(eventManager.events.filter(isActive)) { event in
                        NavigationLink(destination: EventDetailView(event: event)) {
                            EventRowView(event: event)
                        }
                    }
                }
                
                // Section for upcoming events
                Section(header: Text(NSLocalizedString("Upcoming Events", comment: "Header for upcoming events section"))) {
                    ForEach(upcomingEvents.prefix(showAllUpcoming ? eventManager.events.count : 2)) { event in
                        NavigationLink(destination: EventDetailView(event: event)) {
                            EventRowView(event: event)
                        }
                    }
                    if upcomingEvents.count > 2 {
                        Button(action: {
                            showAllUpcoming.toggle()
                        }) {
                            Text(showAllUpcoming ? NSLocalizedString("Show Less...", comment: "Button text to show fewer events") : NSLocalizedString("Show More Events...", comment: "Button text to show more events"))
                        }
                    }
                }
                
                // Section for past events
                Section(header: Text(NSLocalizedString("Past Events", comment: "Header for past events section"))) {
                    ForEach(eventManager.events.filter(isPast)) { event in
                        NavigationLink(destination: EventDetailView(event: event)) {
                            EventRowView(event: event)
                        }
                    }
                }
            }
            .navigationTitle(NSLocalizedString("Events", comment: "Navigation title for events"))
            .onAppear {
                eventManager.fetchEvents()
            }
        }
    }
    
    // Determines if an event is currently active
    private func isActive(event: Event) -> Bool {
        let today = Date()
        guard let fromDate = dateFormatter.date(from: event.from),
              let toDate = dateFormatter.date(from: event.to) else {
                  print("Error parsing date for event: \(event.eventTitle)")
                  return false
              }
        return fromDate <= today && toDate >= today
    }
    
    // Filters upcoming events
    private var upcomingEvents: [Event] {
        eventManager.events.filter { event in
            guard let fromDate = dateFormatter.date(from: event.from) else { return false }
            return fromDate > Date()
        }
    }
    
    // Determines if an event is in the past
    private func isPast(event: Event) -> Bool {
        guard let toDate = dateFormatter.date(from: event.to) else { return false }
        return toDate < Date()
    }
    
    // Date formatter for event dates
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
}

#Preview {
    HomeView()
}
