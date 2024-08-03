//
//  PublicTransportRowView.swift
//  ArCamp
//
//  Created by Mantas Ercius on 11.07.24.
//

import SwiftUI

// View displaying a single row for an upcoming tram departure
struct PublicTransportRowView: View {
    var departure: UpcomingDeparture  // The upcoming departure to display
    
    var body: some View {
        HStack {
            // Line number with purple background
            Text(departure.line)
                .font(.headline)
                .padding(.vertical)
                .padding(.horizontal, 10)
                .foregroundColor(.white)
                .background(Color.purple)
                .cornerRadius(22)
            
            VStack(alignment: .leading) {
                // Destination
                Text(departure.destination)
                    .font(.title3)
                    .fontWeight(.bold)
                
                // Time remaining until departure
                Text(String(format: NSLocalizedString("in %d minutes", comment: "Time remaining until departure"), timeRemaining(from: departure.nextDeparture)))
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding(.vertical, 5)
    }
    
    // Calculates the time remaining from now to the given date in minutes
    private func timeRemaining(from date: Date) -> Int {
        let now = Date()
        let components = Calendar.current.dateComponents([.minute], from: now, to: date)
        return components.minute ?? 0
    }
}

#Preview {
    PublicTransportRowView(departure: UpcomingDeparture(line: "5", destination: "Central Station", nextDeparture: Date().addingTimeInterval(600)))
}
