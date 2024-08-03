//
//  EventDetailView.swift
//  ArCamp
//
//  Created by Mantas Ercius on 11.07.24.
//

import SwiftUI

// View displaying detailed information about an event
struct EventDetailView: View {
    let event: Event  // The event to display
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                // Event cover image
                if let url = URL(string: event.coverURL) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                    } placeholder: {
                        Color.gray
                    }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    // Event title
                    Text(event.eventTitle)
                        .font(.title)
                        .padding(.horizontal)
                        .padding(.bottom, 10)
                    
                    // Description label
                    Text(NSLocalizedString("Description", comment: "Label for event description"))
                        .bold()
                        .font(.headline)
                        .padding(.horizontal)
                        .padding(.bottom, 10)
                    
                    // Event description
                    Text(event.description)
                        .font(.body)
                        .padding(.horizontal)
                        .padding(.bottom, 10)
                    
                    // Event date range
                    HStack {
                        Image(systemName: "calendar")
                        Text(eventDateRange())
                            .bold()
                    }
                    .font(.subheadline)
                    .padding(.horizontal)
                    .foregroundColor(.secondary)
                }
                .padding(.top, 8)
            }
            .padding(.bottom)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    Text(event.eventTitle).font(.headline)
                }
            }
        }
    }
    
    // Returns the event date range as a formatted string
    private func eventDateRange() -> String {
        if event.to.isEmpty {
            return event.from
        } else {
            return String(format: NSLocalizedString("%@ - %@", comment: "Event date range"), event.from, event.to)
        }
    }
}

#Preview {
    EventDetailView(event: Event(id: "1", eventTitle: "Sample Event", from: "2024-07-27", to: "2024-07-28", coverURL: "https://example.com/image.jpg", description: "Sample event description"))
}
