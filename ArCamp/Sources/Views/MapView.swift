//
//  MapView.swift
//  ArCamp
//
//  Created by Mantas Ercius on 08.07.24.
//

import SwiftUI
import MapKit

// View displaying a map with building annotations
struct MapView: View {
    @StateObject private var buildingManager = BuildingManager()  // Manages building data
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 52.457, longitude: 13.527),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    @State private var selectedBuilding: Building? = nil  // Tracks the selected building
    @State private var showBuildingDetail = false  // Controls the display of building detail view
    
    var body: some View {
        NavigationView {
            ZStack {
                // Map view with building annotations
                Map(coordinateRegion: $region, annotationItems: buildingManager.buildings) { building in
                    MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: building.latitude, longitude: building.longitude)) {
                        Button(action: {
                            selectedBuilding = building
                        }) {
                            VStack {
                                Text(building.shortName)
                                    .font(.headline)
                                    .padding(5)
                                    .foregroundColor(.white)
                                    .background(Color.green)
                                    .cornerRadius(5)
                            }
                        }
                    }
                }
                .onAppear {
                    buildingManager.fetchBuildings()
                }
                
                // Detail view for selected building
                if let selectedBuilding = selectedBuilding {
                    VStack {
                        Spacer()
                        VStack {
                            Text(selectedBuilding.name)
                                .font(.headline)
                                .padding(.vertical)
                            
                            HStack {
                                // Button for AR Navigation (Placeholder)
                                Button(action: {
                                    // Action for AR Navigation
                                }) {
                                    Text("🗺️ AR")
                                        .padding()
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                }
                                Spacer()
                                // Button to open building location in Apple Maps
                                Button(action: {
                                    openAppleMaps(for: selectedBuilding)
                                }) {
                                    Text("🗺️ MAP")
                                        .padding()
                                        .background(Color.green)
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                }
                                Spacer()
                                // Navigation link to building detail view
                                NavigationLink(destination: BuildingDetailView(building: selectedBuilding), isActive: $showBuildingDetail) {
                                    Button(action: {
                                        showBuildingDetail = true
                                    }) {
                                        Text("ℹ️")
                                            .padding()
                                            .background(Color.gray)
                                            .foregroundColor(.white)
                                            .cornerRadius(8)
                                    }
                                }
                            }
                            .padding()
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(12)
                        .padding()
                    }
                }
            }
        }
    }
    
    // Opens the selected building location in Apple Maps
    private func openAppleMaps(for building: Building) {
        let coordinates = CLLocationCoordinate2D(latitude: building.latitude, longitude: building.longitude)
        let placemark = MKPlacemark(coordinate: coordinates)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = building.name
        mapItem.openInMaps(launchOptions: [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ])
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
