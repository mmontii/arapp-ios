//
//  PublicTransportView.swift
//  ArCamp
//
//  Created by Mantas Ercius on 08.07.24.
//

import SwiftUI
import MapKit

// View displaying public transport options and navigation
struct PublicTransportView: View {
    @StateObject private var tramLineManager = TramLineManager()  // Manages tram line data
    
    var body: some View {
        NavigationView {
            List {
                // Section for navigation buttons
                Section(header: Text(NSLocalizedString("Navigate to Tram Station", comment: "Header for navigation buttons section"))) {
                    HStack {
                        // Button for AR Navigation (Placeholder)
                        Button(action: {
                            // Action for AR Navigation button (does nothing)
                        }) {
                            Text("AR Navigation")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        Spacer()
                        // Button to open Apple Maps for navigation
                        Button(action: {
                            openAppleMaps()
                        }) {
                            Text("Map Navigation")
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                    .padding(.vertical)
                }
                
                // Section for upcoming tram lines
                Section(header: Text(NSLocalizedString("Upcoming Tram Lines", comment: "Header for upcoming tram lines section"))) {
                    ForEach(calculateUpcomingDepartures()) { departure in
                        PublicTransportRowView(departure: departure)
                    }
                }
            }
            .navigationTitle(NSLocalizedString("Tram", comment: "Navigation title for the tram view"))
            .onAppear {
                tramLineManager.fetchTramLines()
            }
        }
    }
    
    // Opens the location in Apple Maps
    private func openAppleMaps() {
        let latitude: CLLocationDegrees = 52.45867774638792
        let longitude: CLLocationDegrees = 13.526008774768272
        let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let placemark = MKPlacemark(coordinate: coordinates)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "Destination"
        mapItem.openInMaps(launchOptions: [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ])
    }
    
    // Calculates upcoming tram departures
    private func calculateUpcomingDepartures() -> [UpcomingDeparture] {
        var upcomingDepartures: [UpcomingDeparture] = []
        let now = Date()
        let calendar = Calendar.current

        for tramLine in tramLineManager.tramLines {
            guard let startTime = calendar.date(bySettingHour: getHour(from: tramLine.start_time),
                                                minute: getMinute(from: tramLine.start_time),
                                                second: 0, of: now),
                  let endTime = calendar.date(bySettingHour: getHour(from: tramLine.end_time),
                                              minute: getMinute(from: tramLine.end_time),
                                              second: 0, of: now) else {
                continue
            }
            
            var nextDeparture = startTime
            
            while nextDeparture <= endTime {
                if nextDeparture > now {
                    let departure = UpcomingDeparture(line: tramLine.line, destination: tramLine.destination, nextDeparture: nextDeparture)
                    upcomingDepartures.append(departure)
                    if upcomingDepartures.count == 100 { return upcomingDepartures }
                }
                nextDeparture = calendar.date(byAdding: .minute, value: tramLine.interval_minutes, to: nextDeparture)!
            }
        }
        return upcomingDepartures.sorted { $0.nextDeparture < $1.nextDeparture }
    }
    
    // Helper function to get hour from time string
    private func getHour(from time: String) -> Int {
        let components = time.split(separator: ":")
        return Int(components[0]) ?? 0
    }
    
    // Helper function to get minute from time string
    private func getMinute(from time: String) -> Int {
        let components = time.split(separator: ":")
        return Int(components[1]) ?? 0
    }
    
    // Formats date to string
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    // Calculates time remaining from now to the given date
    private func timeRemaining(from date: Date) -> String {
        let now = Date()
        let components = Calendar.current.dateComponents([.minute], from: now, to: date)
        return components.minute.map { "\($0) \(NSLocalizedString("minutes left", comment: "Time remaining label"))" } ?? "N/A"
    }
}

// Represents an upcoming tram departure
struct UpcomingDeparture: Identifiable {
    let id = UUID()
    let line: String
    let destination: String
    let nextDeparture: Date
}

#Preview {
    PublicTransportView()
}
