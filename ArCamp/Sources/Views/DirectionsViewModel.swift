//
//  DirectionsViewModel.swift
//  ArCamp
//
//  Created by Mantas Ercius on 21.07.24.
//

import Foundation
import MapKit

class DirectionsViewModel: ObservableObject {
    @Published var route: MKRoute?
    
    func getDirections(to destination: CLLocationCoordinate2D) {
        let request = MKDirections.Request()
        request.source = MKMapItem.forCurrentLocation()
        let destinationPlacemark = MKPlacemark(coordinate: destination)
        request.destination = MKMapItem(placemark: destinationPlacemark)
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        directions.calculate { [weak self] response, error in
            guard let response = response, error == nil else {
                print("Error getting directions: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            self?.route = response.routes.first
        }
    }
}
