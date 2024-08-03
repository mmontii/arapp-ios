//
//  ContentView.swift
//  ArCamp
//
//  Created by Mantas Ercius on 08.07.24.
//

import SwiftUI

// Main view of the ArCamp app with a tab bar for navigation
struct ContentView: View {
    @State private var selectedTab = 2  // Keeps track of the selected tab
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Tab for public transport view
            PublicTransportView()
                .tabItem {
                    Image(systemName: "bus")
                    Text(NSLocalizedString("TRAM", comment: ""))
                }
                .tag(0)
            
            // Tab for augmented reality view
            ArView()
                .tabItem {
                    Image(systemName: "camera.metering.center.weighted")
                    Text(NSLocalizedString("AR View", comment: ""))
                }
                .tag(1)
            
            // Tab for home view with events
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text(NSLocalizedString("Events", comment: ""))
                }
                .tag(2)
            
            // Tab for map view
            MapView()
                .tabItem {
                    Image(systemName: "map")
                    Text(NSLocalizedString("Map", comment: ""))
                }
                .tag(3)
            
            // Tab for locations view
            LocationsView()
                .tabItem {
                    Image(systemName: "list.bullet.circle")
                    Text(NSLocalizedString("Locations", comment: ""))
                }
                .tag(4)
        }
    }
}

#Preview {
    ContentView()
}
