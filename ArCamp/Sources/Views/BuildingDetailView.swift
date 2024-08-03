//
//  BuildingDetailView.swift
//  ArCamp
//
//  Created by Mantas Ercius on 11.07.24.
//

import SwiftUI
import MapKit

// View displaying detailed information about a building
struct BuildingDetailView: View {
    var building: Building  // The building to display
    @State private var showNavigationButtons = false  // Controls the display of navigation buttons
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    
                    // Building image
                    AsyncImage(url: URL(string: building.imageUrl)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity)
                    } placeholder: {
                        ProgressView()
                            .frame(height: 200)
                    }
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(8)

                    // Building description
                    Group {
                        Text(NSLocalizedString("Description", comment: "Building description label"))
                            .font(.headline)
                        Text(building.description)
                            .font(.body)
                            .padding()
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(8)
                    }
                    .padding(.bottom, 10)
                    
                    // Building details
                    Group {
                        HStack {
                            Image(systemName: "mappin.and.ellipse")
                            Text(NSLocalizedString("Campus", comment: "Campus label"))
                                .font(.headline)
                            Text(building.campus)
                                .font(.body)
                                .padding(.leading, 5)
                        }

                        HStack {
                            Image(systemName: "map.fill")
                            Text(NSLocalizedString("Address", comment: "Address label"))
                                .font(.headline)
                            Text(building.address)
                                .padding(.bottom, 5)
                        }
                    }
                    .padding(.bottom, 10)
                    
                    // Hours of operation
                    Group {
                        Text(NSLocalizedString("Hours of Operation", comment: "Hours of operation label"))
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        VStack(alignment: .center) {
                            Text("\(NSLocalizedString("Monday to Friday", comment: "Monday to Friday label")): \(building.hours_of_operation.monday_to_friday)")
                            Text("\(NSLocalizedString("Saturday", comment: "Saturday label")): \(building.hours_of_operation.saturday)")
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(8)
                    }
                    .padding(.bottom, 10)
                    
                    // Facilities
                    Group {
                        Text(NSLocalizedString("Facilities", comment: "Facilities label"))
                            .font(.headline)
                        VStack(spacing: 10) {
                            ForEach(building.facilities.indices, id: \.self) { index in
                                Text(building.facilities[index])
                                    .font(.footnote)
                                    .padding(5)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(colors[index % colors.count])
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .padding(.bottom, 10)
                }
                .padding()
            }
            
            // Navigation buttons
            VStack {
                if showNavigationButtons {
                    Button(action: {
                        // AR button action
                    }) {
                        Text("AR")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                    .transition(.move(edge: .trailing))
                    
                    Button(action: {
                        openAppleMaps(for: building)
                    }) {
                        Text("MAP")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                    .transition(.move(edge: .trailing))
                }
                
                Button(action: {
                    withAnimation {
                        showNavigationButtons.toggle()
                    }
                }) {
                    Text("🧭")
                        .font(.largeTitle)
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }
            }
            .padding()
        }
        .navigationTitle(building.name)
        .onTapGesture {
            if showNavigationButtons {
                withAnimation {
                    showNavigationButtons = false
                }
            }
        }
    }
    
    private let colors: [Color] = [.green, .orange, .red, .purple, .pink, .blue]
    
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
