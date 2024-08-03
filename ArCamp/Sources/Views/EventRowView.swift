//
//  EventRowView.swift
//  ArCamp
//
//  Created by Mantas Ercius on 11.07.24.
//

import SwiftUI

// View displaying a single row for an event in a list
struct EventRowView: View {
    let event: Event  // The event to display
    
    var body: some View {
        HStack {
            // Event cover image
            if let url = URL(string: event.coverURL) {
                AsyncImage(url: url) { image in
                    image.resizable()
                } placeholder: {
                    Color.gray
                }
                .frame(width: 50, height: 50)
                .cornerRadius(5)
            }
            
            VStack(alignment: .leading) {
                // Event title
                Text(event.eventTitle)
                    .font(.headline)
                
                // Event start date
                Text(event.from)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    EventRowView(event: Event(id: "1", eventTitle: "Sample Event", from: "2024-07-27", to: "2024-07-28", coverURL: "https://example.com/image.jpg", description: "Sample event description"))
}
