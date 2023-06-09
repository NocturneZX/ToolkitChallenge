//
//  MapView.swift
//  ToolkitChallenge
//
//  Created by Julio Reyes on 3/11/23.
//

import Foundation
import MapKit
import SwiftUI
import Combine
import DTMHeatmap

struct MapView: UIViewRepresentable {
    
    @Binding var centerCoordinate: CLLocationCoordinate2D
    @Binding var location: CLLocation?
    
    var mapTile: UIImage?

    var annotations: [MKPointAnnotation]
    var span: MKCoordinateSpan

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        if annotations.count != uiView.annotations.count {
            uiView.removeAnnotations(uiView.annotations)
            uiView.addAnnotations(annotations)
        }
                
        guard let location = location else { return }
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        uiView.setRegion(region, animated: true)
        
        // Heatmap
        // Update heatmap
        uiView.removeOverlays(uiView.overlays)
        
        for annotation in annotations {
            let location = CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
            let point = MKMapPoint(location.coordinate)
            let pointVal = NSValue(mkMapPoint: point)
            // Based of the map point, it will create a heatmap overlay underneath the point annotation
            addHeatmapOverlay(to: uiView, data: [pointVal:30] as [AnyHashable : Any])
        }
        
        self.setupTileRenderer(uiView)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView

        init(_ parent: MapView) {
            self.parent = parent
        }
        
        func mapViewDidChangeRegion(_ mapView: MKMapView)  {
            parent.centerCoordinate = mapView.centerCoordinate
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let tileOverlay = overlay as? MKTileOverlay {
                return MKTileOverlayRenderer(tileOverlay: tileOverlay)
            } else {
                return DTMHeatmapRenderer(overlay: overlay)
            }
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            annotationView.isEnabled = false
            return annotationView
        }
    }
    
    private func setupTileRenderer(_ uiView: MKMapView) {
      let overlay = MapTileOverlay(image: mapTile ?? UIImage())
        overlay.canReplaceMapContent = false
        uiView.addOverlay(overlay, level: .aboveRoads)
    }
    
    // Create the heatmap overlay
    private func addHeatmapOverlay(to mapView: MKMapView, data: [AnyHashable: Any]?) {
        let heatMap = DTMHeatmap()
        heatMap.setData(data! as [AnyHashable : Any])
        mapView.addOverlay(heatMap)
    }
}
