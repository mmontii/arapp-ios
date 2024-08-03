//
//  LocationsView.swift
//  ArCamp
//
//  Created by Mantas Ercius on 08.07.24.
//

import SwiftUI

// View displaying a list of buildings with an option to view a campus map
struct LocationsView: View {
    @StateObject private var buildingManager = BuildingManager()  // Manages building data
    @State private var showMap = false  // Controls the display of the campus map
    
    var body: some View {
        NavigationView {
            ZStack {
                // List of buildings with navigation links to building detail views
                List(buildingManager.buildings) { building in
                    NavigationLink(destination: BuildingDetailView(building: building)) {
                        BuildingRowView(building: building)
                    }
                }
                .navigationTitle(NSLocalizedString("Buildings", comment: "Navigation title for the buildings list"))
                .onAppear {
                    buildingManager.fetchBuildings()
                }
                
                // Floating button to show the campus map
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            showMap.toggle()
                        }) {
                            Image(systemName: "info.circle")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.green)
                                .clipShape(Circle())
                                .shadow(radius: 10)
                        }
                        .padding()
                        .sheet(isPresented: $showMap) {
                            NavigationView {
                                ImageViewer(showMap: $showMap)
                            }
                        }
                    }
                }
            }
        }
    }
}

// View for displaying the campus map image
struct ImageViewer: View {
    @Binding var showMap: Bool  // Binding to control the display of the map
    
    var body: some View {
        VStack {
            // Asynchronously loads and displays the campus map image
            AsyncImage(url: URL(string: "https://projekte.htw-berlin.de/files/Presse/_tmp_/e/c/csm_HTW_Berlin_Lageplaen_WH_HdT_86aed83f54.jpg")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                ProgressView()
            }
            .navigationTitle(NSLocalizedString("Campus Map", comment: "Navigation title for the campus map"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // Toolbar button to dismiss the map view
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(NSLocalizedString("Dismiss", comment: "Dismiss button")) {
                        showMap.toggle()
                    }
                }
            }
        }
    }
}

#Preview {
    LocationsView()
}
