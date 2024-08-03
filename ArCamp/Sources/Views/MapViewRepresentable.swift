//
//  MapViewRepresentable.swift
//  ArCamp
//
//  Created by Mantas Ercius on 21.07.24.
//
import SwiftUI
import MapKit

struct MapViewRepresentable: UIViewRepresentable {
    var region: MKCoordinateRegion
    var buildings: [Building]
    var route: MKRoute?
    var onBuildingTap: (Building) -> Void

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.setRegion(region, animated: true)
        return mapView
    }

    func updateUIView(_ mapView: MKMapView, context: Context) {
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)

        for building in buildings {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: building.latitude, longitude: building.longitude)
            annotation.title = building.shortName
            mapView.addAnnotation(annotation)
        }

        if let route = route {
            mapView.addOverlay(route.polyline)
            let rect = route.polyline.boundingMapRect
            mapView.setVisibleMapRect(rect, edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50), animated: true)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapViewRepresentable

        init(_ parent: MapViewRepresentable) {
            self.parent = parent
        }

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let identifier = "Building"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView

            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
                annotationView?.pinTintColor = .red

                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleAnnotationTap(_:)))
                annotationView?.addGestureRecognizer(tapGesture)
            } else {
                annotationView?.annotation = annotation
            }

            return annotationView
        }

        @objc func handleAnnotationTap(_ sender: UITapGestureRecognizer) {
            guard let view = sender.view as? MKAnnotationView, let annotation = view.annotation as? MKPointAnnotation else { return }

            if let building = parent.buildings.first(where: { $0.shortName == annotation.title }) {
                parent.onBuildingTap(building)
            }
        }

        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = .blue
                renderer.lineWidth = 5
                return renderer
            }
            return MKOverlayRenderer()
        }
    }
}
